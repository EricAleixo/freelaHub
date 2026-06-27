import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "grid"]

  connect() {
    this.files = []
    this.render()
  }

  add(event) {
    const selected = Array.from(event.target.files)

    for (const file of selected) {
      if (this.files.length >= 8) break
      this.files.push(file)
    }

    event.target.value = ""

    this.syncInput()
    this.render()
  }

  openPicker() {
    this.inputTarget.click()
  }

  remove(event) {
    const index = Number(event.currentTarget.dataset.index)

    this.files.splice(index, 1)

    this.syncInput()
    this.render()
  }

  syncInput() {
    const dt = new DataTransfer()

    this.files.forEach(file => dt.items.add(file))

    this.inputTarget.files = dt.files
  }

  render() {
    this.gridTarget.innerHTML = ""

    this.files.forEach((file, index) => {
      const item = document.createElement("div")
      item.className =
        "relative aspect-square rounded-xl overflow-hidden border border-gray-200"

      if (file.type.startsWith("image")) {
        const img = document.createElement("img")
        img.src = URL.createObjectURL(file)
        img.className = "w-full h-full object-cover"
        item.appendChild(img)
      } else {
        const video = document.createElement("video")
        video.src = URL.createObjectURL(file)
        video.className = "w-full h-full object-cover"
        video.muted = true
        video.playsInline = true
        item.appendChild(video)
      }

      const remove = document.createElement("button")
      remove.type = "button"
      remove.dataset.index = index
      remove.innerHTML = "✕"
      remove.className =
        "absolute top-1 right-1 w-6 h-6 rounded-full bg-black/70 text-white text-xs"

      remove.addEventListener("click", this.remove.bind(this))

      item.appendChild(remove)

      this.gridTarget.appendChild(item)
    })

    // botão +
    if (this.files.length < 8) {
      const add = document.createElement("button")

      add.type = "button"

      add.className =
        "aspect-square rounded-xl border-2 border-dashed border-gray-300 hover:border-indigo-500 hover:bg-indigo-50 flex items-center justify-center transition"

      add.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg"
             class="w-8 h-8 text-gray-400"
             fill="none"
             viewBox="0 0 24 24"
             stroke="currentColor"
             stroke-width="2">
          <path stroke-linecap="round"
                stroke-linejoin="round"
                d="M12 4v16m8-8H4"/>
        </svg>
      `

      add.addEventListener("click", () => this.openPicker())

      this.gridTarget.appendChild(add)
    }
  }
}