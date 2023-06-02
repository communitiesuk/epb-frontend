/**
 * @jest-environment jsdom
 */
/* eslint-env jest */
import { copyToClipboard } from '../share-certificate.js'

describe('when a browser supports copying and permissions are granted', () => {
  Object.assign(navigator, {
    clipboard: {
      writeText: jest.fn()
    },
    permissions: {
      query: jest.fn()
    }
  })

  beforeAll(() => {
    navigator.clipboard.writeText.mockResolvedValue(undefined)
    navigator.permissions.query.mockResolvedValue({ name: 'clipboard-write', state: 'granted' })
    copyToClipboard()
  })

  it('should call clipboard.writeText', () => {
    expect(navigator.clipboard.writeText).toHaveBeenCalled()
  })
})

describe('when a browser supports copying and permissions are prompted', () => {
  Object.assign(navigator, {
    clipboard: {
      writeText: jest.fn()
    },
    permissions: {
      query: jest.fn()
    }
  })

  beforeAll(() => {
    navigator.clipboard.writeText.mockResolvedValue(undefined)
    navigator.permissions.query.mockResolvedValue({ name: 'clipboard-write', state: 'prompt' })
    copyToClipboard()
  })

  it('should call clipboard.writeText', () => {
    expect(navigator.clipboard.writeText).toHaveBeenCalled()
  })
})

describe('when a browser recognises the clipboard-write permission but it is not granted', () => {
  Object.assign(navigator, {
    permissions: {
      query: jest.fn()
    }
  })
  Object.assign(document, {
    execCommand: jest.fn()
  })

  beforeAll(() => {
    navigator.permissions.query.mockResolvedValue({ name: 'clipboard-write', state: 'denied' })
    copyToClipboard()
  })

  it('should call document.execCommand with copy', () => {
    expect(document.execCommand).toHaveBeenCalledWith('copy')
  })
})

describe('when a browser does not recognise the clipboard-write permission', () => {
  Object.assign(navigator, {
    permissions: {
      query: jest.fn()
    }
  })
  Object.assign(document, {
    execCommand: jest.fn()
  })

  beforeAll(() => {
    navigator.permissions.query.mockRejectedValue(new TypeError("'clipboard-write' (value of 'name' member of PermissionDescriptor) is not a valid value for enumeration PermissionName."))
    copyToClipboard()
  })

  it('should call document.execCommand with copy', () => {
    expect(document.execCommand).toHaveBeenCalledWith('copy')
  })
})
