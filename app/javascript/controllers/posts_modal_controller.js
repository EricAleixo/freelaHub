import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "overlay", "sheet", "titleInput", "descInput", "errorMsg",
    "formEl", "methodInput", "modeLabel", "submitBtn", "existingGrid"
  ]
  static values = { postsPath: String }

  connect() {
    this._keydown = (e) => { if (e.key === "Escape") this.close() }
    document.addEventListener("keydown", this._keydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this._keydown)
  }

  open() {
    this._resetToCreateMode()
    this._show()
  }

  openEdit(event) {
    const btn = event.currentTarget
    const id = btn.dataset.postId
    const title = btn.dataset.postTitle || ""
    const description = btn.dataset.postDescription || ""
    const jobId = btn.dataset.postJobId || ""
    const attachments = JSON.parse(btn.dataset.postAttachments || "[]")

    // Aponta o form para o update do post certo
    this.formElTarget.action = `${this.postsPathValue}/${id}`
    this.methodInputTarget.value = "patch"
    this.modeLabelTarget.textContent = "Editar publicação"
    this.submitBtnTarget.textContent = "Salvar"

    this.titleInputTarget.value = title
    this.descInputTarget.value = description

    // Vaga vinculada
    const jobHidden = this.formElTarget.querySelector('[data-job-link-target="hiddenInput"]')
    if (jobHidden) jobHidden.value = jobId

    if (jobId) {
      const jobEl = this.formElTarget.querySelector(`[data-job-id="${jobId}"]`)
      if (jobEl) jobEl.click()
    }

    this._renderExistingAttachments(attachments)
    this._show()
  }

  _renderExistingAttachments(attachments) {
    if (!this.hasExistingGridTarget) return
    this.existingGridTarget.innerHTML = ""

    if (!attachments.length) {
      this.existingGridTarget.classList.add("hidden")
      return
    }

    this.existingGridTarget.classList.remove("hidden")

    attachments.forEach((att) => {
      const wrapper = document.createElement("div")
      wrapper.className = "relative aspect-square rounded-lg overflow-hidden border border-gray-200 group"
      wrapper.dataset.signedId = att.signed_id

      if (att.image) {
        const img = document.createElement("img")
        img.src = att.url
        img.className = "w-full h-full object-cover"
        wrapper.appendChild(img)
      } else {
        const placeholder = document.createElement("div")
        placeholder.className = "w-full h-full flex items-center justify-center bg-gray-800 text-white text-xs"
        placeholder.textContent = "Vídeo"
        wrapper.appendChild(placeholder)
      }

      const removeBtn = document.createElement("button")
      removeBtn.type = "button"
      removeBtn.innerHTML = "&times;"
      removeBtn.className = "absolute top-1 right-1 w-5 h-5 rounded-full bg-black/60 text-white flex items-center justify-center text-xs leading-none border-0 cursor-pointer"
      removeBtn.addEventListener("click", () => {
        const hidden = document.createElement("input")
        hidden.type = "hidden"
        hidden.name = "post[remove_attachment_signed_ids][]"
        hidden.value = att.signed_id
        this.formElTarget.appendChild(hidden)
        wrapper.remove()
      })

      wrapper.appendChild(removeBtn)
      this.existingGridTarget.appendChild(wrapper)
    })
  }

  _resetToCreateMode() {
    this.formElTarget.reset()
    this.formElTarget.action = this.postsPathValue
    this.methodInputTarget.value = "post"
    this.modeLabelTarget.textContent = "Nova publicação"
    this.submitBtnTarget.textContent = "Publicar"

    this.formElTarget
      .querySelectorAll('input[name="post[remove_attachment_signed_ids][]"]')
      .forEach((el) => el.remove())

    if (this.hasExistingGridTarget) {
      this.existingGridTarget.innerHTML = ""
      this.existingGridTarget.classList.add("hidden")
    }

    const jobHidden = this.formElTarget.querySelector('[data-job-link-target="hiddenInput"]')
    if (jobHidden) jobHidden.value = ""
    const jobClear = this.formElTarget.querySelector('[data-action="click->job-link#clear"]')
    if (jobClear) jobClear.click()

    this.errorMsgTarget.classList.add("hidden")
  }

  _show() {
    this.overlayTarget.style.display = "block"
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        this.sheetTarget.classList.remove("translate-y-full")
        this.sheetTarget.classList.add("translate-y-0")
      })
    })
  }

  close() {
    this.sheetTarget.classList.remove("translate-y-0")
    this.sheetTarget.classList.add("translate-y-full")
    setTimeout(() => {
      this.overlayTarget.style.display = "none"
    }, 300)
  }

  submit(event) {
    const title = this.titleInputTarget.value.trim()
    const desc  = this.descInputTarget.value.trim()

    if (!title) {
      event.preventDefault()
      this._showError("Informe um título.")
      this.titleInputTarget.focus()
      return
    }
    if (!desc) {
      event.preventDefault()
      this._showError("Informe uma descrição.")
      this.descInputTarget.focus()
      return
    }
    this.errorMsgTarget.classList.add("hidden")
  }

  _showError(msg) {
    this.errorMsgTarget.textContent = msg
    this.errorMsgTarget.classList.remove("hidden")
  }
}