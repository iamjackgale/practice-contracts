# IPFS Notes

This tutorial works with JS-IPFS - the JavaScript implementation of the IPFS specification - on Yarn.

See the [Github page](https://github.com/ipfs/js-ipfs/blob/master/) and the [Yarn package page](https://yarnpkg.com/package/ipfs) for more details.

## Installation

First, install IPFS using the following command:

_yarn add ipfs_

## Help

For further details of the available commands/tasks for JS-IPFS, run the following command:

_yarn jsipfs help_

## Initialisation

To start working with JS-IPFS, run the following initialisation command:

_yarn jsipfs init_

This will confirm that it is initialising an IPFS node and generating an ED25519 keypair. It will then prompt you to get started with a suggestion command with the following format:

_yarn jsipfs cat /ipfs/<HASH>/readme_

This should prompt a ASCII welcome and confirm that you have successfully installed IPFS and are now interfacing with the IPFS merkledag.

## IPFS Daemon

When you're ready to take your node to a public network, run the IPFS daemon in a separate termination using the following command:

_yarn jsipfs daemon_

In the main terminal, you can then see the IPFS addresses of your peers with the following command:

_yarn jsipfs swarm peers_

## Create an IPFS Link to the Image

You can then create an IPFS link for an image in the same directory using the following command:

_yarn jsipfs add <image.png>_

The CLI will then confirm that it has added a hash starting with QM, following by the file name, for example:

_added QmPxvsQLAJmsGYpVxobP3zYrYTkcmzpWLMYyxRgafRdJ7D PickleBeach.png_

The hash can then be used to reach the IPFS link to the file by adding it to the following prefix, for example:

https://ipfs.io/ipfs/QmPxvsQLAJmsGYpVxobP3zYrYTkcmzpWLMYyxRgafRdJ7D

## Create a NFT JSON file

Next you should create a JSON file in the same directory which incorporates the IPFS image link, using the following schema:

_{_
_"name": "<NFT Name>",_
_"description": "<NFT Description>",_
_"image": "<IPFS Image Link>",_
_}_

## Create an IPFS Link to the JSON File

Then you can create an IPFS link for the JSON file in the same directory, using the following command:

_yarn jsipfs add <JSONFile.json>_

And the CLI will again confirm the IPFS link by issuing a hash in the same was as for the image:

_added QmQFo8Aqw7FsLAKEXzzgyn6hfC3dvSUaWt2c4dRCW6w6VC PickleBeach.json_

Which gives rise to the following IPFS link:

https://ipfs.io/ipfs/QmQFo8Aqw7FsLAKEXzzgyn6hfC3dvSUaWt2c4dRCW6w6VC
