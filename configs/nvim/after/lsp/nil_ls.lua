-- Fetch missing flake inputs automatically instead of prompting.
return {
  settings = {
    ['nil'] = {
      nix = {
        flake = {
          autoArchive = true,
        },
      },
    },
  },
}
