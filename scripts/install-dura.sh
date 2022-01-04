brew install rustup && brew install rust
git clone git@github.com:tkellogg/dura.git
cd dura
# Note: If you receive a failure fetching the cargo dependencies try using the local git client for cargo fetches.
# cargo install --path
CARGO_NET_GIT_FETCH_WITH_CLI=true cargo install --path .
