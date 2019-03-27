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

public class App : Gtk.Application {

    public App () {
        Object (
            application_id: "com.github.hanscronau.qr",
            flags: ApplicationFlags.NON_UNIQUE
        );
    }

    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 300;
        main_window.default_width = 300;
        main_window.title = "QR";
        main_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new App ();
        return app.run (args);
    }
}

