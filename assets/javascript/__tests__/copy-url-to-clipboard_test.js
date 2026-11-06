import { beforeEach, expect, test, jest } from '@jest/globals'
import { screen } from '@testing-library/dom'
import '@testing-library/jest-dom/jest-globals'
import userEvent from '@testing-library/user-event'

import '../copy-url-to-clipboard.js'

function createButton () {
  document.body.innerHTML = `
    <epb-copy-url-to-clipboard>
      <button type="button">
        <slot name="action-message" class="epb-copy-button__label">
          Copy
        </slot>
        <slot name="success-message" class="epb-copy-button__label" hidden>
          Copied
        </slot>
       </button>
    </epb-copy-url-to-clipboard>
  `
}

beforeEach(() => {
  const writeText = jest.fn(async () => true)
  Object.defineProperty(navigator, 'clipboard', {
    configurable: true,
    value: { writeText }
  })
})

test('copies the location', async () => {
  createButton()

  const button = screen.getByRole('button', { name: 'Copy' })
  await userEvent.click(button)
  expect(button).toHaveAccessibleName('Copied')
  expect(button).toHaveAttribute('aria-live', 'polite')
  expect(navigator.clipboard.writeText).toHaveBeenCalledWith(window.location.href)
})

test('flips the label back to copy after 5 seconds', async () => {
  jest.useFakeTimers()
  const user = userEvent.setup({ advanceTimers: jest.advanceTimersByTime })
  createButton()

  const button = screen.getByRole('button', { name: 'Copy' })
  await user.click(button)
  await user.tab()
  jest.advanceTimersByTime(4000)
  expect(button).toHaveAccessibleName('Copied')
  jest.advanceTimersByTime(1000)
  expect(button).toHaveAccessibleName('Copy')
  expect(button).not.toHaveAttribute('aria-live')
})

test('does not flip the label back to copy if the button is focused', async () => {
  jest.useFakeTimers()
  const user = userEvent.setup({ advanceTimers: jest.advanceTimersByTime })
  createButton()

  const button = screen.getByRole('button', { name: 'Copy' })
  await user.click(button)
  jest.advanceTimersByTime(6000)
  expect(button).toHaveAccessibleName('Copied')
  await user.tab()
  expect(button).toHaveAccessibleName('Copy')
})

test('waits 5 seconds from when the last copy action', async () => {
  jest.useFakeTimers()
  const user = userEvent.setup({ advanceTimers: jest.advanceTimersByTime })
  createButton()

  const button = screen.getByRole('button', { name: 'Copy' })
  await user.click(button)
  jest.advanceTimersByTime(4000)
  expect(button).toHaveAccessibleName('Copied')
  await user.click(button)
  await user.tab()
  jest.advanceTimersByTime(4000)
  expect(button).toHaveAccessibleName('Copied')
  jest.advanceTimersByTime(1000)
  expect(button).toHaveAccessibleName('Copy')
})

test('is hidden if navigator clipboard is not available', async () => {
  delete navigator.clipboard
  createButton()

  expect(screen.queryByRole('button', { name: 'Copy' })).not.toBeInTheDocument()
})
