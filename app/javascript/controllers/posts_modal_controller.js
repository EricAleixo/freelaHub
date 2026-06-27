import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "sheet", "titleInput", "descInput", "errorMsg"]

  connect() {
    this._keydown = (e) => { if (e.key === "Escape") this.close() }
    document.addEventListener("keydown", this._keydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this._keydown)
  }

  open() {
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
    this.errorMsgTarget.style.display = "none"
  }

  _showError(msg) {
    this.errorMsgTarget.textContent = msg
    this.errorMsgTarget.style.display = "block"
  }
}