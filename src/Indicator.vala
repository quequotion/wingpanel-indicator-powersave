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
    public const string CPU_PATH = "/sys/devices/system/cpu/";

    public class Indicator : Wingpanel.Indicator {

        private Widgets.PanelWidget? cpu_freq = null;
        private Widgets.PopoverWidget? main_widget = null;
        private uint timeout_id = 0;

        public bool intel_pstate {
            get; construct set;
        }

        private GLib.Settings settings;

        public Indicator () {
            Object (code_name: "powersave-indicator",
                    intel_pstate: GLib.FileUtils.test (CPU_PATH + "intel_pstate", FileTest.IS_DIR));

            settings = new GLib.Settings ("io.elementary.desktop.wingpanel.powersave");

            string def_sw = Utils.get_content ("/etc/throttle.d/systemstate");

            if (def_sw != "on") {
                settings.set_boolean ("system-wide", true);
            } else {
                settings.set_boolean ("system-wide", false);
            }

            //on_changed_sw ();

            if (intel_pstate) {

                string def_boost = Utils.get_content (CPU_PATH + "intel_pstate/no_turbo");
                //on_changed_tb ();

                settings.changed["turbo-boost"].connect (on_changed_tb);
            }

            string def_ht = Utils.get_content (CPU_PATH + "smt/control");

            if (def_ht != "on") {
                settings.set_boolean ("hyperthreads", false);
            } else {
                settings.set_boolean ("hyperthreads", true);
            }

            //on_changed_ht ();

            string def_governor = Utils.get_content (CPU_PATH + "cpu0/cpufreq/scaling_governor");

            if (def_governor != "performance") {
                settings.set_boolean ("governor", false);
            } else {
                settings.set_boolean ("governor", true);
            }

            //on_changed_governor ();

            //string def_gpu = Utils.get_content (CPU_PATH + "smt/control");

            //if (def_gpu != "on") {
            //    settings.set_boolean ("gpu", true);
            //} else {
            //    settings.set_boolean ("gpu", false);
            //}

            //on_changed_gpu ();

            settings.changed["system-wide"].connect (on_changed_sw);

            settings.changed["hyperthreads"].connect (on_changed_ht);

            settings.changed["governor"].connect (on_changed_governor);

            settings.changed["gpu"].connect (on_changed_gpu);

            visible = Utils.can_manage ();
        }

        public override Gtk.Widget get_display_widget () {
            if (cpu_freq == null) {
                cpu_freq = new Widgets.PanelWidget ();
                if (visible && update ()) {
                    timeout_id = GLib.Timeout.add (2000, update);
                }
            }

            return cpu_freq;
        }

        public override Gtk.Widget? get_widget () {
            if (main_widget == null) {
                if (visible) {
                    main_widget = new Widgets.PopoverWidget (settings, intel_pstate);
                } else {
                    return null;
                }
            }

            return main_widget;
        }

        private void on_changed_tb () {
            Utils.set_turbo_boost (settings.get_boolean ("turbo-boost"));
        }

        protected void on_changed_governor () {
            Utils.set_governor (settings.get_boolean ("governor"));
        }

        private void on_changed_ht () {
            Utils.set_ht (settings.get_boolean ("hyperthreads"));
        }

        private void on_changed_gpu () {
            Utils.set_gpu (settings.get_boolean ("gpu"));
        }

        private void on_changed_sw () {
            Utils.set_sw (settings.get_boolean ("system-wide"));
        }

        public unowned bool update () {
            double cur_freq = Utils.get_cur_frequency ();
            cpu_freq.add_label (cur_freq);

            return cur_freq != 0;
        }

        public override void opened () {}

        public override void closed () {}
    }
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Powersave Indicator");
    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }

    var indicator = new Powersave.Indicator ();
    return indicator;
}
