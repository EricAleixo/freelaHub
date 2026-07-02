import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["passwordInput", "passwordToggle", "eyeOn", "eyeOff"]

  togglePassword() {
    const input = this.passwordInputTarget
    const isHidden = input.type === "password"

    input.type = isHidden ? "text" : "password"

    this.eyeOffTarget.classList.toggle("hidden", isHidden)
    this.eyeOnTarget.classList.toggle("hidden", !isHidden)
  }
}