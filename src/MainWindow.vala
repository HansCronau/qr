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

        public MainWindow (Gtk.Application application) {
            Object (application: application,
                    resizable: false,
                    title: "QR");

            this.get_style_context().add_class("rounded");
            this.get_style_context().add_class("default-decoration");

            var header = new Gtk.HeaderBar();
            header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            header.set_show_close_button (true);
            header.title = this.title;
            this.set_titlebar(header);

            int small_space = 6;

            var main_grid = new Gtk.Grid ();
            main_grid.margin = small_space;

            var left_right_grid = new Gtk.Grid ();
            left_right_grid.column_homogeneous = true;
            left_right_grid.column_spacing = 40;


            var left_label = new Gtk.Label ("Text");
            left_label.hexpand = true;
            left_right_grid.attach (left_label, 0, 0);


            var left_grid = new Gtk.Grid ();
            left_grid.expand = true;
            left_grid.orientation = Gtk.Orientation.VERTICAL;
            left_grid.row_spacing = small_space;

            var input_frame = new Gtk.Frame (null);

            var input_scrolled = new Gtk.ScrolledWindow (null, null);

            var input_text = new Gtk.TextView ();
            input_text.expand = true;
            input_text.wrap_mode = Gtk.WrapMode.WORD_CHAR;
            input_scrolled.add (input_text);

            input_frame.add (input_scrolled);
            left_grid.add (input_frame);

            left_right_grid.attach (left_grid, 0, 1);
            
            input_text.grab_focus ();

            var qr_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            qr_box.height_request = 20;
            qr_box.hexpand = true;
            qr_box.halign = Gtk.Align.CENTER;

            var right_label = new Gtk.Label ("QR Code");
            qr_box.add (right_label);

            var qr_settings_popover = new Gtk.Popover (null);
            var qr_settings_box = new Gtk.Box (Gtk.Orientation.VERTICAL, small_space);
            qr_settings_box.margin = small_space;

            var error_correction_label = new Gtk.Label ("Error correction");
            error_correction_label.halign = Gtk.Align.START;
            qr_settings_box.add (error_correction_label);

            var error_correction_range = new Gtk.Scale.with_range (
                Gtk.Orientation.HORIZONTAL,
                0,
                3,
                1
            );
            error_correction_range.set_value (1);
            error_correction_range.width_request = 140;
            error_correction_range.format_value.connect ((value) => {
                if (value < 0.5) {
                    return "Low";
                }
                else if (value < 1.5) {
                    return "Medium";
                }
                else if (value < 2.5) {
                    return "Quartile";
                }
                else {
                    return "High";
                }
            });
            qr_settings_box.add (error_correction_range);
            qr_settings_box.show_all ();
            qr_settings_popover.add (qr_settings_box);

            var qr_settings_button = new Gtk.MenuButton();
            qr_settings_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            qr_settings_button.has_tooltip = true;
            qr_settings_button.tooltip_text = ("QR Settings");
            qr_settings_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            qr_settings_button.popover = qr_settings_popover;
            qr_box.add (qr_settings_button);

            left_right_grid.attach (qr_box, 1, 0);


            var right_grid = new Gtk.Grid ();
            right_grid.expand = true;
            right_grid.orientation = Gtk.Orientation.VERTICAL;
            right_grid.row_spacing = small_space;

            var preview_frame = new Gtk.Frame (null);

            var preview_image = new Gtk.Image ();
            preview_image.set_size_request (300, 300);
            preview_image.hexpand = true;
            preview_frame.add (preview_image);
            right_grid.add (preview_frame);

            var save_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            save_box.get_style_context ().add_class (Gtk.STYLE_CLASS_LINKED);

            var save_button = new Gtk.Button.with_label ("Save");
            save_button.hexpand = true;
            save_box.add (save_button);

            var save_settings_popover = new Gtk.Popover (null);
            var save_settings_box = new Gtk.Box (Gtk.Orientation.VERTICAL, small_space);
            save_settings_box.margin = small_space;

            var save_type_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, small_space);
            var save_type_label = new Gtk.Label ("Save as");
            save_type_label.halign = Gtk.Align.START;
            save_type_box.add (save_type_label);

            var save_type_combobox = new Gtk.ComboBoxText ();
            save_type_combobox.append ("png", "PNG");
            save_type_combobox.append ("svg", "SVG");
            save_type_combobox.active_id = "svg";
            save_type_box.add (save_type_combobox);

            save_settings_box.add (save_type_box);
            save_settings_box.show_all ();
            save_settings_popover.add (save_settings_box);

            var save_settings_button = new Gtk.MenuButton();
            save_settings_button.has_tooltip = true;
            save_settings_button.tooltip_text = ("Save Settings");
            save_settings_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            save_settings_button.popover = save_settings_popover;
            save_box.add (save_settings_button);

            right_grid.add (save_box);
            
            left_right_grid.attach (right_grid, 1, 1);


            input_text.buffer.changed.connect (() => {
                if (update_timeout_id > 0) {
                    return;
                }
                update_timeout_id = Timeout.add (300, () => {
                    updatePreview.begin(input_text.buffer.text, preview_image);
                    update_timeout_id = 0;
                    return false;
                });
            });


            main_grid.add(left_right_grid);


            this.add (main_grid);
        }
    }
}
