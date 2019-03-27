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

