
\dontrun{
# The `secret` package contains some user keys for demonstration purposes.
# In this example, Alice shares a secret with Bob using a vault.

keys <- function(x){
  file.path(system.file("user_keys", package = "secret"), x)
}
alice_public  <- keys("alice.pub")
alice_private <- keys("alice.pem")
bob_public  <- keys("bob.pub")
bob_private <- keys("bob.pem")
carl_private <- keys("carl.pem")

# Create vault

vault <- file.path(tempdir(), ".vault")
if (dir.exists(vault)) unlink(vault) # ensure vault is empty
create_vault(vault)

# Add users with their public keys

add_user("alice", public_key = alice_public, vault = vault)
add_user("bob", public_key = bob_public, vault = vault)
list_users(vault = vault)

# Share a secret

secret <- list(username = "user123", password = "Secret123!")

add_secret("secret", value = secret, users = c("alice", "bob"),
           vault = vault)
list_secrets(vault = vault)

# Alice and Bob can decrypt the secret with their private keys
# Note that you would not normally have access to the private key
# of any of your collaborators!

get_secret("secret", key = alice_private, vault = vault)
get_secret("secret", key = bob_private, vault = vault)

# But Carl can't decrypt the secret

try(
  get_secret("secret", key = carl_private, vault = vault)
)

# Unshare the secret

unshare_secret("secret", users = "bob", vault = vault)
try(
  get_secret("secret", key = bob_private, vault = vault)
)


# Delete the secret

delete_secret("secret", vault = vault)
list_secrets(vault)

# Delete the users

delete_user("alice", vault = vault)
delete_user("bob", vault = vault)
list_users(vault)

}
