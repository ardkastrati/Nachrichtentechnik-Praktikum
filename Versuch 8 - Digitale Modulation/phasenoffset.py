#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Verhalten bei Phasenoffset
# Author: Martin Braun
# Description: Was bewirkt eine Phasenaenderung?
# Generated: Mon Jul 17 17:02:14 2017
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

from gnuradio import analog
from gnuradio import blocks
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio import wxgui
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from gnuradio.wxgui import forms
from gnuradio.wxgui import numbersink2
from gnuradio.wxgui import scopesink2
from grc_gnuradio import blks2 as grc_blks2
from grc_gnuradio import wxgui as grc_wxgui
from optparse import OptionParser
import math
import numpy
import wx


class phasenoffset(grc_wxgui.top_block_gui):

    def __init__(self):
        grc_wxgui.top_block_gui.__init__(self, title="Verhalten bei Phasenoffset")

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 100e3
        self.phase_offset = phase_offset = 0
        self.fO = fO = 0
        self.constellation = constellation = digital.constellation_qpsk()
        self.EbN0 = EbN0 = 10

        ##################################################
        # Blocks
        ##################################################
        _phase_offset_sizer = wx.BoxSizer(wx.VERTICAL)
        self._phase_offset_text_box = forms.text_box(
        	parent=self.GetWin(),
        	sizer=_phase_offset_sizer,
        	value=self.phase_offset,
        	callback=self.set_phase_offset,
        	label='Phase Offset',
        	converter=forms.float_converter(),
        	proportion=0,
        )
        self._phase_offset_slider = forms.slider(
        	parent=self.GetWin(),
        	sizer=_phase_offset_sizer,
        	value=self.phase_offset,
        	callback=self.set_phase_offset,
        	minimum=0,
        	maximum=1,
        	num_steps=100,
        	style=wx.SL_HORIZONTAL,
        	cast=float,
        	proportion=1,
        )
        self.Add(_phase_offset_sizer)
        _fO_sizer = wx.BoxSizer(wx.VERTICAL)
        self._fO_text_box = forms.text_box(
        	parent=self.GetWin(),
        	sizer=_fO_sizer,
        	value=self.fO,
        	callback=self.set_fO,
        	label='Frequency Offset',
        	converter=forms.float_converter(),
        	proportion=0,
        )
        self._fO_slider = forms.slider(
        	parent=self.GetWin(),
        	sizer=_fO_sizer,
        	value=self.fO,
        	callback=self.set_fO,
        	minimum=0,
        	maximum=1,
        	num_steps=100,
        	style=wx.SL_HORIZONTAL,
        	cast=float,
        	proportion=1,
        )
        self.Add(_fO_sizer)
        _EbN0_sizer = wx.BoxSizer(wx.VERTICAL)
        self._EbN0_text_box = forms.text_box(
        	parent=self.GetWin(),
        	sizer=_EbN0_sizer,
        	value=self.EbN0,
        	callback=self.set_EbN0,
        	label='Eb/N0 (dB)',
        	converter=forms.float_converter(),
        	proportion=0,
        )
        self._EbN0_slider = forms.slider(
        	parent=self.GetWin(),
        	sizer=_EbN0_sizer,
        	value=self.EbN0,
        	callback=self.set_EbN0,
        	minimum=-10,
        	maximum=200,
        	num_steps=211,
        	style=wx.SL_HORIZONTAL,
        	cast=float,
        	proportion=1,
        )
        self.Add(_EbN0_sizer)
        self.wxgui_scopesink2_0 = scopesink2.scope_sink_c(
        	self.GetWin(),
        	title="Constellation: "+str(constellation.arity()) + "-PSK",
        	sample_rate=samp_rate,
        	v_scale=0,
        	v_offset=0,
        	t_scale=0,
        	ac_couple=True,
        	xy_mode=True,
        	num_inputs=1,
        	trig_mode=wxgui.TRIG_MODE_AUTO,
        	y_axis_label='Counts',
        )
        self.GridAdd(self.wxgui_scopesink2_0.win, 2, 0, 1, 1)
        self.wxgui_numbersink2 = numbersink2.number_sink_f(
        	self.GetWin(),
        	unit='%',
        	minval=0.0,
        	maxval=1.0,
        	factor=100,
        	decimal_places=4,
        	ref_level=0,
        	sample_rate=samp_rate,
        	number_rate=15,
        	average=False,
        	avg_alpha=None,
        	label='BER',
        	peak_hold=False,
        	show_gauge=False,
        )
        self.GridAdd(self.wxgui_numbersink2.win, 1, 0, 1, 1)
        self.digital_constellation_decoder_cb_0 = digital.constellation_decoder_cb(constellation.base())
        self.digital_chunks_to_symbols_xx_0 = digital.chunks_to_symbols_bc((constellation.points()), 1)
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_char*1, samp_rate,True)
        self.blocks_multiply_xx_0 = blocks.multiply_vcc(1)
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_vcc((numpy.exp(1j * 2 * numpy.pi * phase_offset), ))
        self.blocks_add_xx_0 = blocks.add_vcc(1)
        self.blks2_error_rate = grc_blks2.error_rate(
        	type='BER',
        	win_size=int(1e5),
        	bits_per_symbol=constellation.bits_per_symbol(),
        )
        self.analog_sig_source_x_0 = analog.sig_source_c(1, analog.GR_COS_WAVE, fO, 1, 0)
        self.analog_random_source_x_0 = blocks.vector_source_b(map(int, numpy.random.randint(0, constellation.arity(), 10000000)), True)
        self.analog_noise_source_x_0 = analog.noise_source_c(analog.GR_GAUSSIAN, 1.0/math.sqrt(2.0 *2* 10**(EbN0/10)), 0)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_noise_source_x_0, 0), (self.blocks_add_xx_0, 1))
        self.connect((self.analog_random_source_x_0, 0), (self.blocks_throttle_0, 0))
        self.connect((self.analog_random_source_x_0, 0), (self.digital_chunks_to_symbols_xx_0, 0))
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_multiply_xx_0, 1))
        self.connect((self.blks2_error_rate, 0), (self.wxgui_numbersink2, 0))
        self.connect((self.blocks_add_xx_0, 0), (self.digital_constellation_decoder_cb_0, 0))
        self.connect((self.blocks_add_xx_0, 0), (self.wxgui_scopesink2_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.blocks_multiply_xx_0, 0))
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_add_xx_0, 0))
        self.connect((self.blocks_throttle_0, 0), (self.blks2_error_rate, 0))
        self.connect((self.digital_chunks_to_symbols_xx_0, 0), (self.blocks_multiply_const_vxx_0, 0))
        self.connect((self.digital_constellation_decoder_cb_0, 0), (self.blks2_error_rate, 1))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.wxgui_scopesink2_0.set_sample_rate(self.samp_rate)
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)

    def get_phase_offset(self):
        return self.phase_offset

    def set_phase_offset(self, phase_offset):
        self.phase_offset = phase_offset
        self._phase_offset_slider.set_value(self.phase_offset)
        self._phase_offset_text_box.set_value(self.phase_offset)
        self.blocks_multiply_const_vxx_0.set_k((numpy.exp(1j * 2 * numpy.pi * self.phase_offset), ))

    def get_fO(self):
        return self.fO

    def set_fO(self, fO):
        self.fO = fO
        self._fO_slider.set_value(self.fO)
        self._fO_text_box.set_value(self.fO)
        self.analog_sig_source_x_0.set_frequency(self.fO)

    def get_constellation(self):
        return self.constellation

    def set_constellation(self, constellation):
        self.constellation = constellation

    def get_EbN0(self):
        return self.EbN0

    def set_EbN0(self, EbN0):
        self.EbN0 = EbN0
        self._EbN0_slider.set_value(self.EbN0)
        self._EbN0_text_box.set_value(self.EbN0)
        self.analog_noise_source_x_0.set_amplitude(1.0/math.sqrt(2.0 *2* 10**(self.EbN0/10)))


def main(top_block_cls=phasenoffset, options=None):

    tb = top_block_cls()
    tb.Start(True)
    tb.Wait()


if __name__ == '__main__':
    main()
