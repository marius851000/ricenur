{
  make_plasma_workspace_overlay = patch: (
    self: super: {
      libsForQt5 = super.libsForQt5 // {
        plasma5 = super.libsForQt5.plasma5 // {
          plasma-workspace = super.libsForQt5.plasma5.plasma-workspace.overrideAttrs (old: patch self old);
        };
      };
    }
  );
}
