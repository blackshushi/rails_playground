import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.scrollToBottom();

    // Create an observer to watch for new messages
    this.observer = new MutationObserver(this.scrollOnMutation.bind(this));
    this.observer.observe(this.element, {
      childList: true,
      subtree: true,
    });

    // Handle keyboard events for mobile devices
    window.visualViewport.addEventListener(
      "resize",
      this.handleVisualViewportResize.bind(this),
    );

    // Add input focus handler
    document.addEventListener("focusin", this.handleFocusIn.bind(this));

    // Add scroll handler
    this.element.addEventListener("scroll", this.handleScroll.bind(this));

    // Initialize isNearBottom
    this.isNearBottom = true;
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect();
    }
    window.visualViewport.removeEventListener(
      "resize",
      this.handleVisualViewportResize,
    );
    document.removeEventListener("focusin", this.handleFocusIn);
    this.element.removeEventListener("scroll", this.handleScroll);
  }

  // Scroll to bottom when new messages arrive
  scrollOnMutation(mutations) {
    mutations.forEach((mutation) => {
      if (mutation.addedNodes.length > 0) {
        // Only auto-scroll if we're already near the bottom
        if (this.isNearBottom) {
          this.scrollToBottom();
        }
      }
    });
  }

  // Handle mobile keyboard showing/hiding
  handleVisualViewportResize() {
    if (
      document.activeElement.tagName === "TEXTAREA" ||
      document.activeElement.tagName === "INPUT"
    ) {
      // Use setTimeout to ensure this runs after the keyboard is fully shown
      setTimeout(() => this.scrollToBottom(), 100);
    }
  }

  // Handle input focus
  handleFocusIn(event) {
    if (
      event.target.tagName === "TEXTAREA" ||
      event.target.tagName === "INPUT"
    ) {
      // Use setTimeout to handle both keyboard and focus changes
      setTimeout(() => this.scrollToBottom(), 300);
    }
  }

  // Check if user is near bottom while scrolling
  handleScroll() {
    const threshold = 150; // pixels from bottom
    const position =
      this.element.scrollHeight -
      this.element.scrollTop -
      this.element.clientHeight;
    this.isNearBottom = position < threshold;
  }

  scrollToBottom() {
    const scrollHeight = this.element.scrollHeight;
    this.element.scrollTo({
      top: scrollHeight,
      behavior: "smooth",
    });
  }
}
