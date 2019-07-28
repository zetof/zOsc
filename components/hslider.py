from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.properties import StringProperty, NumericProperty


class Hslider(GridLayout):
    widget_name = StringProperty()
    widget_value = NumericProperty()
    widget_group = NumericProperty()
    osc_group = StringProperty()

    def on_touch_down(self, touch):
        app = App.get_running_app()
        if self.collide_point(*touch.pos):
            app.root.set_used_widget(self.widget_name, self.widget_group)
            value = round(100 * (touch.x - self.x) / self.width)
            self.widget_value = value
            app.root.osc.send(self.osc_group, self.widget_name, self.widget_group, value)
        return super(Hslider, self).on_touch_down(touch)

    def on_touch_move(self, touch):
        app = App.get_running_app()
        if app.root.is_used_widget(self.widget_name, self.widget_group):
            value = round(100 * (touch.x - self.x) / self.width)
            if value < 0  and self.widget_value > 0:
                value = 0
            elif value > 100  and self.widget_value < 100:
                value = 100
            if value >= 0 and value <= 100:
                self.widget_value = value
                app.root.osc.send(self.osc_group, self.widget_name, self.widget_group, value)
        return super(Hslider, self).on_touch_move(touch)

    def on_touch_up(self, touch):
        app = App.get_running_app()
        app.root.release_widget()
        return super(Hslider, self).on_touch_up(touch)
