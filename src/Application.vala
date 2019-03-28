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
    public class App : Gtk.Application {

        public App () {
            Object (
                application_id: "com.github.hanscronau.qr",
                flags: ApplicationFlags.NON_UNIQUE
            );
        }

        async void updatePreview (string input, Gtk.Image image) {
            image.pixbuf = yield qrencode(input);
        }

        protected override void activate () {
            var main_window = new Gtk.ApplicationWindow (this);
            main_window.default_height = 300;
            main_window.default_width = 300;
            main_window.title = "QR";

            int small_space = 6;

            var main_grid = new Gtk.Grid ();

            var left_right_grid = new Gtk.Grid ();
            left_right_grid.column_spacing = 42;


            var left_grid = new Gtk.Grid ();
            left_grid.orientation = Gtk.Orientation.VERTICAL;
            left_grid.row_spacing = small_space;

            var left_label = new Gtk.Label ("Text");
            left_grid.add (left_label);

            var input_text = new Gtk.TextView ();
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
                debug(input_text.buffer.text);
                updatePreview.begin(input_text.buffer.text, qr_image);
            });
            

            main_grid.add(left_right_grid);


            main_window.add (main_grid);
            main_window.show_all ();
        }

        public static int main (string[] args) {
            var app = new App ();
            return app.run (args);
        }
    }
}
