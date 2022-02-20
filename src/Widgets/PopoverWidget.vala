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

        public PopoverWidget (GLib.Settings settings, bool pstate) {
            orientation = Gtk.Orientation.HORIZONTAL;
            hexpand = true;
            row_spacing = 2;

            this.settings = settings;

            int top = 0;

            top = add_system_wide (top);

            if (pstate) {
                top = add_turbo_boost (top);
            }

            top = add_hyperthreads (top);
            top = add_governor (top);
            add_gpu (top);
        }

        private int add_governor (int top) {
            var g_top = top;
            var g_switch = new Granite.SwitchModelButton ("CPU Performance");
            g_switch.active = settings.get_boolean("governor");
            settings.bind ("governor", g_switch, "active", GLib.SettingsBindFlags.DEFAULT);
            attach (g_switch, 0, g_top++, 2, 1);

            var separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
            separator.hexpand = true;
            attach (separator, 0, g_top++, 2, 1);

            return g_top;
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
