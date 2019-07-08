from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.gridlayout import GridLayout
from kivy.properties import NumericProperty
from kivy.properties import StringProperty


class Table(GridLayout):
    widget_name = None


class Vslider(GridLayout):
    widget_name = StringProperty()
    widget_value = NumericProperty()

    def on_touch_down(self, touch):
        if self.collide_point(*touch.pos):
            Table.widget_name = self.widget_name
            self.widget_value = round(100 * (touch.y - self.y) / self.height)

    def on_touch_move(self, touch):
        if self.widget_name == Table.widget_name:
            value = round(100 * (touch.y - self.y) / self.height)
            if value < 0:
                value = 0
            elif value > 100:
                value = 100
            self.widget_value = value
            print(self.widget_value)

    def on_touch_up(self, touch):
        Table.widget_name = None

class ZoscApp(App):
    def build(self):
        return Table()

if __name__ == '__main__':
    ZoscApp().run()