import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "counter", "dots"]

  connect() {
    this.index = 0
    this.total = this.trackTarget.children.length

    if (this.total <= 1) return;

    this.buildDots()
    this.update()
  }

  next() {
    this.index = (this.index + 1) % this.total
    this.update()
  }

  prev() {
    this.index = (this.index - 1 + this.total) % this.total
    this.update()
  }

  update() {
    this.trackTarget.style.transform =
      `translateX(-${this.index * 100}%)`

    this.counterTarget.textContent =
      `${this.index + 1} / ${this.total}`

    this.dotsTarget.querySelectorAll("button").forEach((dot, i) => {
      dot.classList.toggle("bg-white", i === this.index)
      dot.classList.toggle("bg-white/40", i !== this.index)
    })
  }

  buildDots() {
    this.dotsTarget.innerHTML = ""

    for (let i = 0; i < this.total; i++) {
      const dot = document.createElement("button")

      dot.type = "button"
      dot.className = "w-2 h-2 rounded-full bg-white/40 transition"

      dot.addEventListener("click", () => {
        this.index = i
        this.update()
      })

      this.dotsTarget.appendChild(dot)
    }
  }
}