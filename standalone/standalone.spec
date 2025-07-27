# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['standalone.py'],
    pathex=['./..'],
    binaries=[],
    datas=[
        ('../audiosrc/*', 'audiosrc'),
        ('../code/*', 'code'),
        ('../css/*', 'css'),
        ('../fontawesome/*', 'fontawesome'),
        ('../fonts/*', 'fonts'),
        ('../img/*', 'img'),
        ('../index.html', '.'),
        ('../program.html', '.'),
        ('../SweetDreams.icon.png', '.')
    ],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='SweetDreams',
    debug=True,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    onefile=True,
    icon='../SweetDreams.icon.png',
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='SweetDreams',
)