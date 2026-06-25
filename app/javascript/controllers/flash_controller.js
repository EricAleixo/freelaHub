import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.remove("-translate-y-full", "opacity-0");
      this.element.classList.add("translate-y-0", "opacity-100");
    }, 100);

    this.timeout = setTimeout(() => {
      this.close();
    }, 4000);
  }

  close() {
    this.element.classList.add("-translate-y-full", "opacity-0");
    this.element.classList.remove("translate-y-0", "opacity-100");
  }

  disconnect() {
    clearTimeout(this.timeout);
  }
}