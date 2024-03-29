from pythonosc import udp_client

class OscClient():

    def __init__(self, host, port):
        self.client = udp_client.SimpleUDPClient(host, port)

    def send(self, url, widget_label, widget_sequence, message):
        if url != '':
            self.client.send_message('/' + url, [widget_label, widget_sequence, message])
