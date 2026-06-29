import { Controller } from "@hotwired/stimulus"
3.
export default class extends Controller {
  static targets = [
    "step",
    "progressBar",
    "progressLabel",
    "fullName",
    "email",
    "username",
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
    if (this.hasProgressLabelTarget) {
      this.progressLabelTarget.textContent = `Step ${stepNumber} of 3`
    }

    this.progressBarTargets.forEach((bar) => {
      const barStep = Number(bar.dataset.step)
      bar.classList.toggle("bg-indigo-500", barStep <= stepNumber)
      bar.classList.toggle("bg-slate-200", barStep > stepNumber)
    })
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
      this.markInvalid(this.fullNameTarget, "Please enter your full name.")
      valid = false
    }

    const emailValue = this.emailTarget.value.trim()
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailPattern.test(emailValue)) {
      this.markInvalid(this.emailTarget, "Please enter a valid email address.")
      valid = false
    }

    if (!this.usernameTarget.value.trim()) {
      this.markInvalid(this.usernameTarget, "Coloque um username")
      valid = false
    }

    return valid
  }

  validateStepTwo() {
    if (!this.roleInputTarget.value) {
      this.showStepTwoError("Please choose how you'll use FreelaHub.")
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

  // ── Força da senha (Step 3) ────────────────────────────

  checkPasswordStrength() {
    const value = this.passwordTarget.value
    let score = 0

    if (value.length >= 12) score += 1
    if (/[A-Z]/.test(value) && /[a-z]/.test(value)) score += 1
    if (/\d/.test(value)) score += 1
    if (/[^A-Za-z0-9]/.test(value)) score += 1

    const levels = [
      { label: "", color: "bg-slate-200" },
      { label: "Weak", color: "bg-red-400" },
      { label: "Fair", color: "bg-amber-400" },
      { label: "Good", color: "bg-indigo-400" },
      { label: "Strong", color: "bg-emerald-500" }
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

  togglePassword() {
    this.togglePasswordVisibility(this.passwordTarget, this.passwordToggleTarget)
  }

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
    if (!this.termsTarget.checked) {
      event.preventDefault()
      this.showTermsError()
    }
  }

  showTermsError() {
    const errorEl = this.element.querySelector("[data-terms-error]")
    if (errorEl) errorEl.classList.remove("hidden")
  }

  // ── Helpers de erro (Step 1) ───────────────────────────

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