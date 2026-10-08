import { expect, describe, test, jest, beforeEach } from '@jest/globals'

import { copyToClipboard } from '../share-certificate.js'

beforeEach(() => {
  Object.assign(navigator, {
    clipboard: {
      writeText: jest.fn(),
      foo: 'bar'
    },
    permissions: {
      query: jest.fn()
    }
  })
})

describe('when a browser supports copying and permissions are granted', () => {
  test.only('should call clipboard.writeText', async () => {
    navigator.clipboard.writeText.mockResolvedValue(undefined)
    navigator.permissions.query.mockResolvedValue({ name: 'clipboard-write', state: 'granted' })
    await copyToClipboard()

    expect(navigator.clipboard.writeText).toHaveBeenCalled()
  })
})

describe('when a browser supports copying and permissions are prompted', () => {
  test('should call clipboard.writeText', async () => {
    navigator.clipboard.writeText.mockResolvedValue(undefined)
    navigator.permissions.query.mockResolvedValue({ name: 'clipboard-write', state: 'prompt' })
    await copyToClipboard()

    expect(navigator.clipboard.writeText).toHaveBeenCalled()
  })
})

describe('when a browser recognises the clipboard-write permission but it is not granted', () => {
  test('should call document.execCommand with copy', async () => {
    navigator.permissions.query.mockResolvedValue({ name: 'clipboard-write', state: 'denied' })
    await copyToClipboard()

    expect(document.execCommand).toHaveBeenCalledWith('copy')
  })
})

describe('when a browser does not recognise the clipboard-write permission', () => {
  test('should call document.execCommand with copy', async () => {
    navigator.permissions.query.mockRejectedValue(new TypeError("'clipboard-write' (value of 'name' member of PermissionDescriptor) is not a valid value for enumeration PermissionName."))
    await copyToClipboard()

    expect(document.execCommand).toHaveBeenCalledWith('copy')
  })
})
