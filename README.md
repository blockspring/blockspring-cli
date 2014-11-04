# Blockspring CLI

The Blockspring CLI is used to manage, run, and deploy cloud functions (we call them "blocks") from the command line.

Once deployed, you can use your blocks from just about anywhere. For more info, check out: https://www.blockspring.com.

## Getting Started

Let's deploy our first block in less than 60 seconds.

To get started, we'll need ruby. If you don't have ruby on your machine, first visit https://www.ruby-lang.org/en/installation/ to install it.

#### Step 1: Install the Blockspring-CLI tool

    $ gem install blockspring-cli

#### Step 2: Login to Blockspring   
We'll need to login with our Blockspring account. No Blockspring account yet? Sign up here first: https://api.blockspring.com/users/sign_up.

    $ blockspring login
    Enter your Blockspring credentials.
    Username or email: jason@example.com
    Password (typing will be hidden):
    You are logged in as jason.

#### Step 3: Create a new block
We can create blocks in ruby, python, javascript, php, or R (and more languages are coming soon). Let's create a ruby block since ruby is already installed on our machine.

    $ blockspring new rb "My new Ruby block"
    Creating directory my-new-ruby-block
    Creating script file my-new-ruby-block/block.rb
    Creating config file my-new-ruby-block/blockspring.json

#### Step 4: Deploy your block
Let's enter our new block's directory and deploy.

    $ cd my-new-ruby-block
    $ blockspring push
    Syncronizing script file ./block.rb
    Syncronizing config file ./blockspring.json

#### Step 5: Visit your block's homepage
Now that our block is now deployed we can visit its homepage to see it in action.

    $ blockspring open
    
That's it! We've deployed our first block. To learn more about the Blockspring-CLI, check out the [API in Detail](#api-in-detail) section below. Otherwise, let's pick out our favorite language and start writing our own blocks.

######Language-Specific Libraries
<table>
  <tr>
    <th>If you prefer this language...</th>
    <th>Use this library...</th>
  </tr>
  <tr>
    <td>Ruby</td>
    <td style="text-align: left"><a href="https://github.com/blockspring/blockspring.rb">https://github.com/blockspring/blockspring.rb</a></td>
  </tr>
  <tr>
    <td>Python</td>
    <td style="text-align: left"><a href="https://github.com/blockspring/blockspring.py">https://github.com/blockspring/blockspring.py</a></td>
  </tr>
  <tr>
    <td>Javascript</td>
    <td style="text-align: left"><a href="https://github.com/blockspring/blockspring.js">https://github.com/blockspring/blockspring.js</a></td>
  </tr>
  <tr>
    <td>PHP</td>
    <td style="text-align: left"><a href="https://github.com/blockspring/blockspring.php">https://github.com/blockspring/blockspring.php</a></td>
  </tr>
  <tr>
    <td>R</td>
    <td style="text-align: left"><a href="https://github.com/blockspring/blockspring.R">https://github.com/blockspring/blockspring.R</a></td>
  </tr>
</table>

<br/>
## API in Detail
Let's explore the Blockspring-CLI tool API in detail.

####Authentication
######LOGIN
You must be logged in to run Blockspring-CLI tool commands.

    $ blockspring login
    
######LOGOUT

    $ blockspring logout

####Block Management
######GET
We can ```GET``` a block down to our local machine. The block will be saved in a new directory and can be edited or even executed locally.

    $ blockspring get <block id>

Below is an example ```GET``` request for the following block: https://api.blockspring.com/pkpp1233/6dd22564137f10b8108ec6c8f354f031. The block id can be found directly in the URL.

    $ blockspring get pkpp1233/6dd22564137f10b8108ec6c8f354f031

######NEW
To create a ```NEW``` block:

    $ blockspring new <language> <block name>
    
Here are explicit commands to create a new block in each supported language:
    
    // Ruby: creates dir w/ block.rb & blockspring.json
    $ blockspring new rb "fun ruby block"
    
    // Python: creates dir w/ block.py & blockspring.json
    $ blockspring new py "fun python block"
    
    // Javascript: creates dir w/ block.js & blockspring.json
    $ blockspring new js "fun javascript block"
    
    // PHP: creates dir w/ block.php & blockspring.json
    $ blockspring new php "fun php block"
    
    // R: creates dir w/ block.R & blockspring.json
    $ blockspring new R "fun R block"
    
The ```NEW``` command creates a working directory for your block and populates that directory with two files: a ```block.*``` (asterisk is for your language of choice - file holds your function) and a ```blockspring.json``` (this file holds the block's configs and additional data).

######PULL
We can ```PULL``` a block's recent changes down to our machine. ```PULL``` is used from our block's working directory.

    $ blockspring pull
    
Note: If the block isn't in a directory on our machine yet, we either need to use ```GET``` to retrieve it or ```NEW``` to create it.
    
######PUSH
We can ```PUSH``` a block's recent changes up to Blockspring. ```PUSH``` is used from our block's working directory.

    $ blockspring push

######OPEN

We can ```OPEN``` our block's homepage on Blockspring. ```OPEN``` is used from our block's working directory.

    $ blockspring open

####Executing Blocks from the Command Line
######RUN
We can execute our blocks directly from the command line with the ```RUN``` command. ```RUN``` can be used to execute blocks remotely, or to execute blocks locally on your machine. Blocks, whether they're executed in the cloud or locally, can easily pipe together with other command-line tools.

Let's execute a block remotely by passing parameters into stdin or via command-line arguments.

    // execute with stdin (recommended).
    $ echo '{"num1": 30, "num2": 50}' | blockspring run <block id>
    
    // execute with args.
    $ blockspring run <block id> --num1=30 --num2=50

Remember, a block id can be found directly in a block's URL. The block id for https://api.blockspring.com/pkpp1233/ce6c7c230d8a4ff4d22ae96654ca4bd2 is pkpp1233/ce6c7c230d8a4ff4d22ae96654ca4bd2. Try running the sum with this block id.

    $ echo '{"num1": 30, "num2": 50}' | blockspring run pkpp1233/ce6c7c230d8a4ff4d22ae96654ca4bd2
    
######RUN:LOCAL

We can also run blocks locally on our computer. Let's do a ```GET``` request to a local directory and then use ```RUN:LOCAL``` to execute that block locally without sending any data to Blockspring.

    $ blockspring get pkpp1233/ce6c7c230d8a4ff4d22ae96654ca4bd2
    $ cd summer-ce6c7c23
    $ echo '{"num1": 30, "num2": 50}' | blockspring run:local python block.py
    
Note: To```RUN``` blocks locally, we need to have the proper runtimes and dependencies installed. This is a Blockspring WIP. To run the above example locally, we need to make sure we have the python runtime and the blockspring python library installed (see [Language-Specific Libraries](#language-specific-libraries)).

####Help

    $ blockspring help

If ```HELP``` isn't particularly helpful for your problem, just email us: <a href="mailto:founders@blockspring.com">founders@blockspring.com</a>

<br/>
## License

MIT - see the license file.

