from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.properties import StringProperty, NumericProperty
from kivy.clock import Clock


class Pad(GridLayout):
    widget_name = StringProperty()
    widget_value = NumericProperty()
    widget_group = NumericProperty()
    osc_group = StringProperty()

    def on_touch_down(self, touch):
        app = App.get_running_app()
        if self.collide_point(*touch.pos):
            app.root.set_used_widget(self.widget_name, self.widget_group)
            self.widget_value = 1
            app.root.osc.send(self.osc_group, self.widget_name, self.widget_group, self.widget_value)
            Clock.schedule_once(self.off, .1)
        return super(Pad, self).on_touch_down(touch)

    def off(self, dt):
        app = App.get_running_app()
        self.widget_value = 0
        app.root.osc.send(self.osc_group, self.widget_name, self.widget_group, self.widget_value)
        app.root.release_widget()
