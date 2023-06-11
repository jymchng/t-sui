# Account Abstraction on SUI with Telegram

This repo is an implementation of account abstraction on the SUI blockchain via Telegram.

!! This is experimental and just for fun. !!

# Roadmap

|Description|Status|
|:---:|:---:|
|Construction of basic structs `Handle`, `TelegramID` and `Account`|![](https://img.shields.io/badge/Completed-Green)|
|Handle `Publisher`, `Display` and even `Kiosk` structs for `Account` as NFTs|![](https://img.shields.io/badge/Uncompleted-red)|

# Get Started

## Install SUI

1. Follow the [guide](https://docs.sui.io/build/install) here to install Sui (basically, install `Rust`, then `cargo install sui`).
2. Navigate to any of the sub-directories in the `packages` sub-directory, e.g. `telegram` or `acct-abstract`.
3. Run the command `sui move build` to compile the move source codes and build them. If there are any errors with compilation, the build will fail with the errors causing the failure shown.
4. A folder named `build` should appear under the current-working-directory. This means that the compilation of move source codes is successful.