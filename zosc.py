from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from client.osc import OscClient
from kivy.lang import Builder

Builder.load_file('components/vslider.kv')
Builder.load_file('components/hslider.kv')
Builder.load_file('components/adsr.kv')
Builder.load_file('components/rslider.kv')


class Table(GridLayout):
    current_used_widget = None
    osc = OscClient('127.0.0.1', 57120)


class ZoscApp(App):
    def build(self):
        return Table()

if __name__ == '__main__':
    ZoscApp().run()