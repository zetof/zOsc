from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.properties import NumericProperty
from kivy.properties import StringProperty


class Rslider(GridLayout):
    widget_name = StringProperty()
    widget_value = NumericProperty()
    widget_sensibility = NumericProperty()
    osc_group = StringProperty()
    last_y_cursor_value = 0

    def on_touch_down(self, touch):
        app = App.get_running_app()
        if self.collide_point(*touch.pos):
            app.root.current_used_widget = self.widget_name
            self.last_y_cursor_value = touch.y
        return super(Rslider, self).on_touch_down(touch)

    def on_touch_move(self, touch):
        app = App.get_running_app()
        if self.widget_name == app.root.current_used_widget:
            value = round(self.widget_value + (touch.y - self.last_y_cursor_value) / self.widget_sensibility)
            if value != self.widget_value:
                self.last_y_cursor_value = touch.y
            if value < 0  and self.widget_value > 0:
                value = 0
            elif value > 100 and self.widget_value < 100:
                value = 100
            if value >=0 and value <= 100:
                self.widget_value = value
                app.root.osc.send(self.osc_group, self.widget_name, value)
        return super(Rslider, self).on_touch_move(touch)

    def on_touch_up(self, touch):
        app = App.get_running_app()
        app.root.current_used_widget = None
        return super(Rslider, self).on_touch_up(touch)
