{
  make_plasma_workspace_overlay = patch: (
    self: super: {
      plasma5Packages = super.plasma5Packages // {
        plasma5 = super.plasma5Packages.plasma5 // {
          plasma-workspace = super.plasma5Packages.plasma5.plasma-workspace.overrideAttrs (old: patch self old);
        };
      };
    }
  );
}
