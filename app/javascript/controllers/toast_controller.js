import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  connect() {
    this.showToast();
  }

  showToast() {
    const container = document.getElementById('toast-container');
    this.removeAllChildrenExceptFirst(container);

    const autoRemoveTime = 3000; // 3 seconds
    setTimeout(() => {
      this.fadeOut(this.element);
    }, autoRemoveTime);
  }

  fadeOut(element) {
    element.classList.add('fade-out');
    setTimeout(() => {
      element.remove();
    }, 500); // Duration of the fade-out effect
  }

  removeToast(event) {
    this.fadeOut(event.currentTarget.closest('.toast-element'));
  }

  removeAllChildrenExceptFirst(container) {
    while (container.children.length > 1) {
      container.removeChild(container.lastChild);
    }
  }
}
