import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "overlay", "sheet", "titleInput", "descInput", "errorMsg", "formEl"
  ]

  connect() {
    this._keydown = (e) => { if (e.key === "Escape") this.close() }
    document.addEventListener("keydown", this._keydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this._keydown)
  }

  open() {
    this._show()
  }

  close() {
    this.sheetTarget.classList.remove("translate-y-0")
    this.sheetTarget.classList.add("translate-y-full")
    setTimeout(() => {
      this.overlayTarget.style.display = "none"
      this._reset()
    }, 300)
  }

  closeOnOverlay(event) {
    if (event.target === this.overlayTarget) this.close()
  }

  _reset() {
    this.formElTarget.reset()

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