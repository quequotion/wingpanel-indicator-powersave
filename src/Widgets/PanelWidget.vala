/*
 * Wingpanel CPU frequency indicator
 * Copyright (c) 2018 Dirli <litandrej85@gmail.com>
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
    public class Widgets.PanelWidget : Gtk.Label {
        public PanelWidget () {
            width_chars = 7;
            label = "-";
        }

        public void add_label (double freq_val) {
            label = freq_val == 0 ? _("off") : Utils.format_frequency (freq_val);

            return;
        }
    }
}
