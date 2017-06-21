#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Author: Benjamin Nuss
# Generated: Wed Jun 21 15:48:28 2017
##################################################

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print "Warning: failed to XInitThreads()"

from gnuradio import blocks
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import filter
from gnuradio import gr
from gnuradio import wxgui
from gnuradio.eng_option import eng_option
from gnuradio.fft import window
from gnuradio.filter import firdes
from gnuradio.wxgui import fftsink2
from gnuradio.wxgui import forms
from grc_gnuradio import blks2 as grc_blks2
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import wx


class top_block(grc_wxgui.top_block_gui):

    def __init__(self):
        grc_wxgui.top_block_gui.__init__(self, title="Top Block")

        ##################################################
        # Variables
        ##################################################
        self.spreading_offon = spreading_offon = 0
        self.samp_rate = samp_rate = 5000
        self.pn_len = pn_len = 32
        self.interpolation = interpolation = 4

        ##################################################
        # Blocks
        ##################################################
        self._spreading_offon_chooser = forms.radio_buttons(
        	parent=self.GetWin(),
        	value=self.spreading_offon,
        	callback=self.set_spreading_offon,
        	label='Spreading Off/On',
        	choices=[0,1],
        	labels=[],
        	style=wx.RA_HORIZONTAL,
        )
        self.Add(self._spreading_offon_chooser)
        self.wxgui_fftsink2_0 = fftsink2.fft_sink_c(
        	self.GetWin(),
        	baseband_freq=0,
        	y_per_div=10,
        	y_divs=10,
        	ref_level=0,
        	ref_scale=2.0,
        	sample_rate=samp_rate*pn_len*interpolation,
        	fft_size=1024,
        	fft_rate=15,
        	average=True,
        	avg_alpha=None,
        	title='FFT Plot',
        	peak_hold=False,
        )
        self.Add(self.wxgui_fftsink2_0.win)
        self.rational_resampler_base_xxx_0 = filter.rational_resampler_base_fff(pn_len, 1, ([1,1,-1,-1,-1,-1,1,-1,-1,1,-1,-1,-1,-1,-1,-1,1,1,1,-1,1,-1,-1,1,-1,1,1,-1,-1,1,-1,0]))
        self.digital_glfsr_source_x_0 = digital.glfsr_source_f(15, True, 0, 1)
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_gr_complex*1, samp_rate*pn_len*interpolation,True)
        self.blocks_repeat_1 = blocks.repeat(gr.sizeof_gr_complex*1, 4)
        self.blocks_repeat_0 = blocks.repeat(gr.sizeof_float*1, 31)
        self.blocks_float_to_complex_1 = blocks.float_to_complex(1)
        self.blks2_selector_0 = grc_blks2.selector(
        	item_size=gr.sizeof_float*1,
        	num_inputs=2,
        	num_outputs=1,
        	input_index=spreading_offon,
        	output_index=0,
        )

        ##################################################
        # Connections
        ##################################################
        self.connect((self.blks2_selector_0, 0), (self.blocks_float_to_complex_1, 0))
        self.connect((self.blocks_float_to_complex_1, 0), (self.blocks_repeat_1, 0))
        self.connect((self.blocks_repeat_0, 0), (self.blks2_selector_0, 0))
        self.connect((self.blocks_repeat_1, 0), (self.blocks_throttle_0, 0))
        self.connect((self.blocks_throttle_0, 0), (self.wxgui_fftsink2_0, 0))
        self.connect((self.digital_glfsr_source_x_0, 0), (self.blocks_repeat_0, 0))
        self.connect((self.digital_glfsr_source_x_0, 0), (self.rational_resampler_base_xxx_0, 0))
        self.connect((self.rational_resampler_base_xxx_0, 0), (self.blks2_selector_0, 1))

    def get_spreading_offon(self):
        return self.spreading_offon

    def set_spreading_offon(self, spreading_offon):
        self.spreading_offon = spreading_offon
        self._spreading_offon_chooser.set_value(self.spreading_offon)
        self.blks2_selector_0.set_input_index(int(self.spreading_offon))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.wxgui_fftsink2_0.set_sample_rate(self.samp_rate*self.pn_len*self.interpolation)
        self.blocks_throttle_0.set_sample_rate(self.samp_rate*self.pn_len*self.interpolation)

    def get_pn_len(self):
        return self.pn_len

    def set_pn_len(self, pn_len):
        self.pn_len = pn_len
        self.wxgui_fftsink2_0.set_sample_rate(self.samp_rate*self.pn_len*self.interpolation)
        self.blocks_throttle_0.set_sample_rate(self.samp_rate*self.pn_len*self.interpolation)

    def get_interpolation(self):
        return self.interpolation

    def set_interpolation(self, interpolation):
        self.interpolation = interpolation
        self.wxgui_fftsink2_0.set_sample_rate(self.samp_rate*self.pn_len*self.interpolation)
        self.blocks_throttle_0.set_sample_rate(self.samp_rate*self.pn_len*self.interpolation)


def main(top_block_cls=top_block, options=None):
    if gr.enable_realtime_scheduling() != gr.RT_OK:
        print "Error: failed to enable real-time scheduling."

    tb = top_block_cls()
    tb.Start(True)
    tb.Wait()


if __name__ == '__main__':
    main()
