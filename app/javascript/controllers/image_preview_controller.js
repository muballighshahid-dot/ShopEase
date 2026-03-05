import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  preview() {
    this.previewTarget.innerHTML = ""

    Array.from(this.inputTarget.files).forEach(file => {
      const reader = new FileReader()

      reader.onload = (e) => {
        const img = document.createElement("img")
        img.src = e.target.result
        img.width = 100
        this.previewTarget.appendChild(img)
      }

      reader.readAsDataURL(file)
    })
  }
}