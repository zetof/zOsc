from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.properties import NumericProperty
from kivy.properties import StringProperty


class Vslider(GridLayout):
    widget_name = StringProperty()
    widget_value = NumericProperty()

    def on_touch_down(self, touch):
        parent = self.parent
        if self.collide_point(*touch.pos):
            parent.widget_name = self.widget_name
            value = round(100 * (touch.y - self.y) / self.height)
            self.widget_value = value
            parent.osc.send('foobar', self.widget_name, value)

    def on_touch_move(self, touch):
        parent = self.parent
        if self.widget_name == parent.widget_name:
            value = round(100 * (touch.y - self.y) / self.height)
            if value < 0:
                value = 0
            elif value > 100:
                value = 100
            self.widget_value = value
            parent.osc.send('foobar', self.widget_name, value)

    def on_touch_up(self, touch):
        parent = self.parent
        parent.widget_name = None
