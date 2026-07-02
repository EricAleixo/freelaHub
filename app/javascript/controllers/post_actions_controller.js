import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editDialog", "deleteDialog"]

  openEdit() {
    this.editDialogTarget.showModal()
  }

  openDelete() {
    this.deleteDialogTarget.showModal()
  }

  closeEdit() {
    this.editDialogTarget.close()
  }

  closeDelete() {
    this.deleteDialogTarget.close()
  }

  closeOnBackdrop(event) {
    if (event.target === this.editDialogTarget) this.closeEdit()
    if (event.target === this.deleteDialogTarget) this.closeDelete()
  }
}