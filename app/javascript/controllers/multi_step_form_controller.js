import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "step",
    "progressBar",
    "progressLine",
    "progressLabel",
    "fullName",
    "email",
    "username",
    "usernameStatus",
    "password",
    "passwordConfirmation",
    "roleInput",
    "roleCard",
    "passwordStrengthBar",
    "passwordStrengthLabel",
    "passwordToggle",
    "passwordConfirmToggle",
    "terms",
    "submitButton"
  ]

  static values = { current: { type: Number, default: 1 } }

  connect() {
    this.usernameAvailable = true
    this.usernameCheckTimeout = null
    this.showStep(this.currentValue)
  }

  // ── Navegação ──────────────────────────────────────────

  next() {
    if (!this.validateStep(this.currentValue)) return

    if (this.currentValue < 3) {
      this.currentValue += 1
      this.showStep(this.currentValue)
    }
  }

  back() {
    if (this.currentValue > 1) {
      this.currentValue -= 1
      this.showStep(this.currentValue)
    }
  }

  showStep(stepNumber) {
    this.stepTargets.forEach((el) => {
      el.classList.toggle("hidden", Number(el.dataset.step) !== stepNumber)
    })
    this.updateProgress(stepNumber)
  }

  updateProgress(stepNumber) {
    this.progressBarTargets.forEach((circle) => {
      const circleStep = Number(circle.dataset.step)
      const isActiveOrDone = circleStep <= stepNumber

      circle.classList.toggle("bg-indigo-600", isActiveOrDone)
      circle.classList.toggle("text-white", isActiveOrDone)
      circle.classList.toggle("bg-indigo-100", !isActiveOrDone)
      circle.classList.toggle("text-indigo-400", !isActiveOrDone)
    })

    this.progressLabelTargets.forEach((label) => {
      const labelStep = Number(label.dataset.step)
      label.classList.toggle("text-indigo-600", labelStep <= stepNumber)
      label.classList.toggle("text-slate-500", labelStep > stepNumber)
    })

    if (this.hasProgressLineTarget) {
      this.progressLineTargets.forEach((line) => {
        const lineStep = Number(line.dataset.step)
        line.classList.toggle("bg-indigo-500", lineStep < stepNumber)
        line.classList.toggle("bg-slate-200", lineStep >= stepNumber)
      })
    }
  }

  // ── Validação por passo ────────────────────────────────

  validateStep(stepNumber) {
    this.clearErrors()

    if (stepNumber === 1) return this.validateStepOne()
    if (stepNumber === 2) return this.validateStepTwo()
    return true
  }

  validateStepOne() {
    let valid = true

    if (!this.fullNameTarget.value.trim()) {
      this.markInvalid(this.fullNameTarget, "Informe seu nome completo.")
      valid = false
    }

    if (!this.usernameTarget.value.trim()) {
      this.markInvalid(this.usernameTarget, "Coloque um nome de usuário.")
      valid = false
    } else if (!this.usernameAvailable) {
      this.markInvalid(this.usernameTarget, "Este nome de usuário já existe.")
      valid = false
    }

    const emailValue = this.emailTarget.value.trim()
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailPattern.test(emailValue)) {
      this.markInvalid(this.emailTarget, "Informe um e-mail válido.")
      valid = false
    }

    if (this.passwordTarget.value.length < 8) {
      this.markInvalid(this.passwordTarget, "A senha deve ter no mínimo 8 caracteres.")
      valid = false
    }

    return valid
  }

  validateStepTwo() {
    if (!this.roleInputTarget.value) {
      this.showStepTwoError("Selecione como você irá usar o FreelaHub.")
      return false
    }
    return true
  }

  // ── Seleção de role (Step 2) ───────────────────────────

  selectRole(event) {
    const card = event.currentTarget
    const role = card.dataset.role

    this.roleInputTarget.value = role

    this.roleCardTargets.forEach((el) => {
      const isSelected = el === card
      el.classList.toggle("border-indigo-500", isSelected)
      el.classList.toggle("ring-2", isSelected)
      el.classList.toggle("ring-indigo-100", isSelected)
      el.classList.toggle("border-slate-200", !isSelected)
    })

    const errorEl = this.element.querySelector("[data-step-two-error]")
    if (errorEl) errorEl.classList.add("hidden")
  }

  showStepTwoError(message) {
    const errorEl = this.element.querySelector("[data-step-two-error]")
    if (errorEl) {
      errorEl.textContent = message
      errorEl.classList.remove("hidden")
    }
  }

  // ── Disponibilidade do username (Step 1) ───────────────

  checkUsernameAvailability() {
    clearTimeout(this.usernameCheckTimeout)

    const value = this.usernameTarget.value.trim()

    if (!this.hasUsernameStatusTarget) return

    if (!value) {
      this.usernameAvailable = true
      this.usernameStatusTarget.textContent = ""
      this.usernameStatusTarget.classList.add("hidden")
      return
    }

    this.usernameStatusTarget.textContent = "Verificando disponibilidade..."
    this.usernameStatusTarget.classList.remove("hidden", "text-red-500", "text-emerald-600")
    this.usernameStatusTarget.classList.add("text-slate-400")

    this.usernameCheckTimeout = setTimeout(() => {
      this.fetchUsernameAvailability(value)
    }, 450)
  }

  async fetchUsernameAvailability(username) {
    try {
      const response = await fetch(`/check_username?username=${encodeURIComponent(username)}`, {
        headers: { "Accept": "application/json" }
      })

      if (!response.ok) throw new Error("Falha na verificação")

      const data = await response.json()

      // Ignora resposta se o usuário já mudou o campo
      if (this.usernameTarget.value.trim() !== username) return

      this.usernameAvailable = !data.exists

      this.usernameStatusTarget.classList.remove("text-slate-400", "text-red-500", "text-emerald-600")

      if (data.exists) {
        this.usernameStatusTarget.textContent = "Este nome de usuário já existe."
        this.usernameStatusTarget.classList.add("text-red-500")
      } else {
        this.usernameStatusTarget.textContent = "Nome de usuário disponível."
        this.usernameStatusTarget.classList.add("text-emerald-600")
      }
    } catch (error) {
      this.usernameAvailable = true
      this.usernameStatusTarget.classList.add("hidden")
    }
  }

  // ── Força da senha (Step 1) ────────────────────────────

  checkPasswordStrength() {
    const value = this.passwordTarget.value
    let score = 0

    if (value.length >= 12) score += 1
    if (/[A-Z]/.test(value) && /[a-z]/.test(value)) score += 1
    if (/\d/.test(value)) score += 1
    if (/[^A-Za-z0-9]/.test(value)) score += 1

    const levels = [
      { label: "", color: "bg-slate-200" },
      { label: "Fraca", color: "bg-red-400" },
      { label: "Mediana", color: "bg-amber-400" },
      { label: "Boa", color: "bg-indigo-400" },
      { label: "Forte", color: "bg-emerald-500" }
    ]

    const level = levels[score]

    this.passwordStrengthBarTargets.forEach((bar, index) => {
      bar.classList.remove("bg-red-400", "bg-amber-400", "bg-indigo-400", "bg-emerald-500", "bg-slate-200")
      bar.classList.add(index < score ? level.color : "bg-slate-200")
    })

    if (this.hasPasswordStrengthLabelTarget) {
      this.passwordStrengthLabelTarget.textContent = level.label || "—"
      this.passwordStrengthLabelTarget.classList.remove("text-red-500", "text-amber-500", "text-indigo-500", "text-emerald-600", "text-slate-400")

      const labelColors = ["text-slate-400", "text-red-500", "text-amber-500", "text-indigo-500", "text-emerald-600"]
      this.passwordStrengthLabelTarget.classList.add(labelColors[score])
    }
  }

  // ── Mostrar/ocultar senha ──────────────────────────────

  togglePasswordConfirmation() {
    this.togglePasswordVisibility(this.passwordConfirmationTarget, this.passwordConfirmToggleTarget)
  }

  togglePasswordVisibility(input, toggleButton) {
    const isPassword = input.type === "password"
    input.type = isPassword ? "text" : "password"
    toggleButton.dataset.visible = isPassword ? "true" : "false"
  }

  // ── Submit final ───────────────────────────────────────

  beforeSubmit(event) {
    let valid = true

    if (this.passwordTarget.value !== this.passwordConfirmationTarget.value) {
      this.markInvalid(this.passwordConfirmationTarget, "As senhas não coincidem.")
      valid = false
    }

    if (!this.termsTarget.checked) {
      this.showTermsError()
      valid = false
    }

    if (!this.usernameAvailable) {
      valid = false
    }

    if (!valid) event.preventDefault()
  }

  showTermsError() {
    const errorEl = this.element.querySelector("[data-terms-error]")
    if (errorEl) errorEl.classList.remove("hidden")
  }

  // ── Helpers de erro ─────────────────────────────────────

  markInvalid(input, message) {
    input.classList.add("border-red-400", "focus:ring-red-200", "focus:border-red-400")
    input.classList.remove("border-slate-200")

    const wrapper = input.closest("[data-field-wrapper]")
    if (wrapper) {
      const errorEl = wrapper.querySelector("[data-field-error]")
      if (errorEl) {
        errorEl.textContent = message
        errorEl.classList.remove("hidden")
      }
    }
  }

  clearErrors() {
    this.element.querySelectorAll("[data-field-error]").forEach((el) => {
      el.classList.add("hidden")
    })
    this.element.querySelectorAll("input").forEach((el) => {
      el.classList.remove("border-red-400", "focus:ring-red-200", "focus:border-red-400")
      el.classList.add("border-slate-200")
    })
  }
}