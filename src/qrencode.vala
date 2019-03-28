/*
* Copyright (c) 2019 Hans Cronau (https://hanscronau.nl)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Hans Cronau <hans@cronau.nl>
*              Peter Uithoven <peter@peteruithoven.nl>
*/

namespace QR {
    public async Gdk.Pixbuf? qrencode (string input, string type = "svg", int size = 10, int margin = 1, int dpi = 90) {
        try {
            string[] command = get_command (input, type, size, margin, dpi);
            debug ("Executing: %s", string.joinv (" ", command));

            string? output = null;
            var subprocess = new Subprocess.newv (command, SubprocessFlags.STDOUT_PIPE);
            yield subprocess.communicate_utf8_async (null, null, out output, null);
            if (subprocess.get_successful()) {
                debug ("Success");
                var loader = new Gdk.PixbufLoader();
                loader.write(output.data);
                loader.close();
                return loader.get_pixbuf();
            } else {
                warning ("Execution failed");
            }
        } catch (Error e) {
            warning ("Error: '%s'", e.message);
        }
        return null;
    }
    private string[] get_command (string input, string type, int size, int margin, int dpi) {
        string command = "qrencode -o - -t %s -s %i -m %i -d %i %s".printf(
            type, size, margin, dpi, input
        );

        string[]? argv = null;
        try {
            Shell.parse_argv (command, out argv);
        } catch (Error e) {
            warning ("Error: '%s'", e.message);
        }
        return argv;
    }
}
