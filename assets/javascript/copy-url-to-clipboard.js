class CopyUrlToClipboardElement extends HTMLElement {
  #timeout

  connectedCallback () {
    if (!navigator.clipboard) {
      this.hidden = true
      return
    }
    this.#button?.addEventListener('click', this.#onClick)
  }

  disconnectedCallback () {
    clearTimeout(this.#timeout)
    this.#button?.removeEventListener('click', this.#onClick)
    this.#button?.removeEventListener('blur', this.#onBlur)
  }

  get #button () {
    return this.querySelector('button')
  }

  #onClick = async (e) => {
    if (e.defaultPrevented) {
      return
    }
    clearTimeout(this.#timeout)
    this.#button.removeEventListener('blur', this.#onBlur)
    try {
      await navigator.clipboard.writeText(window.location.href)
    } catch (e) {
      console.error(e)
      return
    }
    this.#markCopied()
    this.#timeout = setTimeout(() => this.#reset(), 5000)
  }

  #onBlur = () => {
    clearTimeout(this.#timeout)
    this.#timeout = setTimeout(() => this.#reset(), 0)
  }

  #markCopied () {
    this.#button.setAttribute('aria-live', 'polite')
    this.#setSlotHidden('action-message', true)
    this.#setSlotHidden('success-message', false)
  }

  #reset () {
    if (document.activeElement === this.#button) {
      this.#button.addEventListener('blur', this.#onBlur, { once: true })
      return
    }
    this.#button.removeAttribute('aria-live')
    this.#setSlotHidden('action-message', false)
    this.#setSlotHidden('success-message', true)
  }

  #setSlotHidden (name, state) {
    const element = this.querySelector(`slot[name="${name}"]`)
    if (!element) {
      console.warn(`missing slot ${name}`, this)
      return
    }
    element.hidden = state
  }
}

customElements.define('epb-copy-url-to-clipboard', CopyUrlToClipboardElement)
