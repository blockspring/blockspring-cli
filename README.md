# Blockspring CLI

The Blockspring CLI is used to manage and run blocks from the command line.

## Installation

Install via command line:

    $ gem install blockspring-cli

## Usage

### Login with your api.blockspring.com account.
```bash
blockspring login
```

### Create a new block
```bash
blockspring new js "My new JS block"
cd my-new-js-block
```

### Edit your function
```bash
echo "console.log('hi');" > block.js
```

### Push
```bash
blockspring push
```

## License

MIT - see the license file.

