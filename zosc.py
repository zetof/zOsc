from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from client.osc import OscClient
from kivy.lang import Builder
from kivy.core.window import Window

Builder.load_file('components/vslider.kv')
Builder.load_file('components/hslider.kv')
Builder.load_file('components/adsr.kv')
Builder.load_file('components/rslider.kv')
Builder.load_file('components/selector.kv')
Builder.load_file('components/toggle.kv')
Builder.load_file('components/pad.kv')
Builder.load_file('components/group.kv')


class Synth(GridLayout):

    _current_used_widget = None
    osc = OscClient('127.0.0.1', 57120)

    def set_used_widget(self, widget_name, widget_group):
        self._current_used_widget = widget_name + '_' + widget_group

    def is_used_widget(self, widget_name, widget_group):
        if self._current_used_widget == widget_name + '_' + widget_group:
            return True
        else:
            return False

    def release_widget(self):
        self._current_used_widget = None


class ZoscApp(App):

    def build(self):
        return Synth()

    def on_start(self):

        def send_init_value(widget):
            for child in widget.children:
                send_init_value(child)
                if hasattr(child, 'osc_group') and hasattr(child, 'widget_name') and hasattr(child, 'widget_group') and hasattr(child, 'widget_value'):
                    self.root.osc.send(child.osc_group, child.widget_name, child.widget_group, child.widget_value)

        for child in self.root.children:
            send_init_value(child)

        #Window.size = (600, 880)

if __name__ == '__main__':
    ZoscApp().run()