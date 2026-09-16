"""Integration tests against real GNU Stow, never the user's config targets."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]
LINKS = {
    '.config/ghostty/config': 'ghostty/config',
    '.zshrc': 'zsh/.zshrc',
    '.config/starship.toml': 'starship/starship.toml',
    '.config/nvim': 'nvim',
    '.config/herdr/config.toml': 'herdr/config.toml',
}


class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='dotfiles test ')
        self.addCleanup(self.tmp.cleanup)
        self.home = Path(self.tmp.name)

    def run_install(self, *args, ok=True, extra_env=None):
        env = dict(os.environ)
        env.pop('XDG_CONFIG_HOME', None)
        env.update(extra_env or {})
        result = subprocess.run(
            ['/bin/bash', str(REPO / 'install.sh'), '--target', str(self.home), *args],
            cwd=self.home, env=env, text=True, capture_output=True,
        )
        self.assertEqual(result.returncode == 0, ok, result.stdout + result.stderr)
        return result

    def test_dry_run_install_and_repeat(self):
        self.run_install('--dry-run')
        self.assertEqual(list(self.home.iterdir()), [])
        self.run_install()
        before = {}
        for dest, source in LINKS.items():
            path = self.home / dest
            self.assertTrue(path.is_symlink(), dest)
            self.assertEqual(path.resolve(strict=True), (REPO / source).resolve())
            before[dest] = path.lstat().st_mtime_ns
        self.assertFalse((self.home / '.config').is_symlink())
        self.run_install()
        self.assertEqual(before, {p: (self.home / p).lstat().st_mtime_ns for p in LINKS})

    def test_conflict_stops_all_packages(self):
        path = self.home / '.zshrc'
        path.write_text('user content\n')
        self.run_install(ok=False)
        self.assertEqual(path.read_text(), 'user content\n')
        self.assertEqual(list(self.home.iterdir()), [path])

    def test_existing_nvim_directory(self):
        path = self.home / '.config/nvim'
        path.mkdir(parents=True)
        (path / 'init.lua').write_text('-- local edits\n')
        self.run_install(ok=False)
        self.assertEqual((path / 'init.lua').read_text(), '-- local edits\n')
        self.assertFalse((self.home / '.zshrc').exists())

    def test_foreign_and_broken_links(self):
        path = self.home / '.zshrc'
        for source in [REPO / 'zsh/.zshrc', self.home / 'missing']:
            with self.subTest(source=source):
                path.symlink_to(source)
                self.run_install(ok=False)
                self.assertEqual(os.readlink(path), str(source))
                self.assertFalse((self.home / '.config').exists())
                path.unlink()

    def test_symlink_parent(self):
        external = self.home / 'external'
        external.mkdir()
        (self.home / '.config').symlink_to(external, target_is_directory=True)
        self.run_install(ok=False)
        self.assertEqual(list(external.iterdir()), [])

    def test_package_selection_and_personal_stowrc(self):
        (self.home / '.stowrc').write_text('--adopt\n--override=.*\n')
        (self.home / '.zshrc').write_text('preserve me')
        self.run_install('herdr', extra_env={'HOME': str(self.home)})
        self.assertEqual((self.home / '.zshrc').read_text(), 'preserve me')
        self.assertTrue((self.home / '.config/herdr/config.toml').is_symlink())
        self.run_install('zsh', ok=False, extra_env={'HOME': str(self.home)})
        self.assertEqual((self.home / '.zshrc').read_text(), 'preserve me')

    def test_invalid_arguments_and_xdg(self):
        self.run_install('--target', ok=False)
        self.run_install('unknown', ok=False)
        self.run_install('--dry-run', ok=False, extra_env={'XDG_CONFIG_HOME': '/elsewhere'})
        self.assertEqual(list(self.home.iterdir()), [])


if __name__ == '__main__':
    unittest.main(verbosity=2)
