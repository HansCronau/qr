project('com.github.hanscronau.qr', 'vala', 'c')

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/qrencode.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('gdk-pixbuf-2.0')
    ],
    install: true
)

install_data(
    join_paths('data', meson.project_name() + '.desktop'),
    install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data(
    join_paths('data', meson.project_name() + '.appdata.xml'),
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

