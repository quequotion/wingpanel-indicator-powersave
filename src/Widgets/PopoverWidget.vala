/*
 * Wingpanel CPU frequency indicator
 * Copyright (c) 2018-2020 Dirli <litandrej85@gmail.com>
 *
 * Wingpanel Powersave indicator
 * Copyright (c) 2022-2022 Que Quotion <quequotion@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace Powersave {
    public class Widgets.PopoverWidget : Gtk.Grid {
        private GLib.Settings settings;
        private Granite.Widgets.ModeButton gov_box;
        private string[] gov_vars;

        public PopoverWidget (GLib.Settings settings, bool pstate) {
            orientation = Gtk.Orientation.HORIZONTAL;
            hexpand = true;
            row_spacing = 2;

            this.settings = settings;

            int top = 0;

            add_system_wide (top);

            if (pstate) {
                add_turbo_boost (top);
            }

            add_hyperthreads (top);
            add_governor (top);
            add_gpu (top);
        }

        private int add_governor (int top) {
            var g_top = top;

            string current_governor = Utils.get_governor ();

            var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator.hexpand = true;
            attach (separator, 0, g_top++, 2, 1);

            gov_box = new Granite.Widgets.ModeButton ();
            gov_box.orientation = Gtk.Orientation.VERTICAL;
            gov_vars = new string[10];

            //foreach (string gov in Utils.get_available_values ("governors")) {
            foreach (string gov in Utils.get_available_values ()) {
                gov = gov.chomp ();
                int i = gov_box.append_text (gov);

                if (gov == current_governor) {
                    gov_box.selected = i;
                }

                gov_vars[i] = gov;
            }

            attach (gov_box, 0, g_top++, 2, 1);
            gov_box.mode_changed.connect (toggled_governor);

            return g_top;
        }

        private unowned void toggled_governor () {
            if (Utils.get_permission ().allowed) {
                settings.set_string ("governor", gov_vars[gov_box.selected]);
            }
        }

        private int add_turbo_boost (int top) {
            var tb_top = top;
            var tb_switch = new Granite.SwitchModelButton ("Turbo Boost");
            tb_switch.active = settings.get_boolean("turbo-boost");
            settings.bind ("turbo-boost", tb_switch, "active", GLib.SettingsBindFlags.DEFAULT);
            attach (tb_switch, 0, tb_top++, 2, 1);

            var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator.hexpand = true;
            attach (separator, 0, tb_top++, 2, 1);

            return tb_top;
        }

        private int add_hyperthreads (int top) {
            var ht_top = top;
            var ht_switch = new Granite.SwitchModelButton ("Hyperthreads");
            ht_switch.active = settings.get_boolean("hyperthreads");
            settings.bind ("hyperthreads", ht_switch, "active", GLib.SettingsBindFlags.DEFAULT);
            attach (ht_switch, 0, ht_top++, 2, 1);

            var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator.hexpand = true;
            attach (separator, 0, ht_top++, 2, 1);

            return ht_top;
        }

        private int add_gpu (int top) {
            var gpu_top = top;
            var gpu_switch = new Granite.SwitchModelButton ("GPU Performance");
            gpu_switch.active = settings.get_boolean("gpu");
            settings.bind ("gpu", gpu_switch, "active", GLib.SettingsBindFlags.DEFAULT);
            attach (gpu_switch, 0, gpu_top++, 2, 1);

            var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator.hexpand = true;
            attach (separator, 0, gpu_top++, 2, 1);

            return gpu_top;
        }

        private int add_system_wide (int top) {
            var sw_top = top;
            var sw_switch = new Granite.SwitchModelButton ("System Performance");
            sw_switch.active = settings.get_boolean("system-wide");
            settings.bind ("system-wide", sw_switch, "active", GLib.SettingsBindFlags.DEFAULT);
            attach (sw_switch, 0, sw_top++, 2, 1);

            var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator.hexpand = true;
            attach (separator, 0, sw_top++, 2, 1);

            return sw_top;
        }
    }
}
