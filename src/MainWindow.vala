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
    public class MainWindow : Gtk.ApplicationWindow {

        uint update_timeout_id = 0;

        async void updatePreview (string input, Gtk.Image image) {
            var unscaled_buf = yield qrencode (input);
            image.pixbuf = unscaled_buf.scale_simple (300, 300, Gdk.InterpType.NEAREST);
        }

        public MainWindow () {
            this.default_width = 640;
            this.default_height = 400;
            this.title = "QR";

            int small_space = 6;

            var main_grid = new Gtk.Grid ();

            var left_right_grid = new Gtk.Grid ();
            left_right_grid.column_homogeneous = true;
            left_right_grid.column_spacing = 40;


            var left_grid = new Gtk.Grid ();
            left_grid.orientation = Gtk.Orientation.VERTICAL;
            left_grid.row_spacing = small_space;

            var left_label = new Gtk.Label ("Text");
            left_label.hexpand = true;
            left_grid.add (left_label);

            var input_text = new Gtk.TextView ();
            input_text.hexpand = true;
            input_text.wrap_mode = Gtk.WrapMode.WORD_CHAR;
            left_grid.add (input_text);

            left_right_grid.add (left_grid);


            var right_grid = new Gtk.Grid ();
            right_grid.orientation = Gtk.Orientation.VERTICAL;
            right_grid.row_spacing = small_space;

            var right_label = new Gtk.Label ("QR Code");
            right_grid.add (right_label);

            var qr_image = new Gtk.Image ();
            right_grid.add (qr_image);

            var save_button = new Gtk.Button.with_label ("Save");
            right_grid.add (save_button);

            left_right_grid.add (right_grid);


            input_text.buffer.changed.connect (() => {
                if (update_timeout_id > 0) {
                    return;
                }
                update_timeout_id = Timeout.add (300, () => {
                    updatePreview.begin(input_text.buffer.text, qr_image);
                    update_timeout_id = 0;
                    return false;
                });
            });


            main_grid.add(left_right_grid);


            this.add (main_grid);
        }
    }
}
