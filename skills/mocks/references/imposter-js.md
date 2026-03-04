# Imposter JS - JavaScript/Node.js Test Bindings

Embed Imposter mocks directly in your JavaScript or TypeScript tests using the [imposter-js](https://github.com/imposter-project/imposter-js) library.

## Prerequisites

- Node.js 14+
- Docker (the library runs Imposter in a container)

## Installation

```bash
npm install --save-dev @imposter-js/imposter
```

## Usage

### From a configuration directory

If you have existing Imposter configuration files:

```javascript
const { mocks } = require('@imposter-js/imposter');

// Start mock from config directory
const mock = await mocks.start('./mocks');

// The mock server URL
const baseUrl = mock.baseUrl();
console.log(`Mock running at: ${baseUrl}`);

// Use the mock in your tests...

// Stop when done
await mock.stop();
```

### From an OpenAPI specification

```javascript
const { mocks } = require('@imposter-js/imposter');

const mock = await mocks.builder()
    .withOpenApiSpec('./petstore.yaml')
    .start();

const baseUrl = mock.baseUrl();

// Call the mock
const response = await fetch(`${baseUrl}/pets`);

await mock.stop();
```

## Jest integration example

```javascript
const { mocks } = require('@imposter-js/imposter');

describe('User API', () => {
    let mock;

    beforeAll(async () => {
        mock = await mocks.start('./mocks');
        process.env.API_URL = mock.baseUrl();
    });

    afterAll(async () => {
        await mock.stop();
    });

    test('should fetch users', async () => {
        const response = await fetch(`${mock.baseUrl()}/users`);
        expect(response.status).toBe(200);

        const users = await response.json();
        expect(users).toHaveLength(2);
    });
});
```

## Builder API

The builder provides programmatic control over mock configuration:

```javascript
const mock = await mocks.builder()
    .withOpenApiSpec('./api.yaml')     // Use an OpenAPI spec
    .withPort(3000)                    // Custom port
    .start();
```

## Links

- [imposter-js repository](https://github.com/imposter-project/imposter-js)
- [imposter-js-types (TypeScript)](https://github.com/imposter-project/imposter-js-types)
