import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const PawaneCiuApp());
}

// --- Enums for State Management ---
enum Status { idle, processing, success, error, offline }

// --- Meter Model ---
class Meter {
  final String serialNumber;
  final String location;
  final bool isActive;
  final DateTime lastUpdate;

  Meter({
    required this.serialNumber,
    required this.location,
    required this.isActive,
    required this.lastUpdate,
  });
}

class PawaneCiuApp extends StatelessWidget {
  const PawaneCiuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawane CIU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E10),
        textTheme: GoogleFonts.robotoMonoTextTheme(ThemeData.dark().textTheme),
      ),
      home: const CiuScreen(),
    );
  }
}

class CiuScreen extends StatefulWidget {
  const CiuScreen({super.key});

  @override
  State<CiuScreen> createState() => _CiuScreenState();
}

class _CiuScreenState extends State<CiuScreen> with TickerProviderStateMixin {
  String _token = '';
  Status _status = Status.idle;
  final int _maxTokenLength = 20;
  bool _isPowerOn = true;

  late AnimationController _pulseController;
  late AnimationController _scanController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  // Meter management
  int _selectedMeterIndex = 0;
  final List<Meter> _meters = [
    Meter(
      serialNumber: 'PWN-2024-001',
      location: 'Building A - Main',
      isActive: true,
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Meter(
      serialNumber: 'PWN-2024-002',
      location: 'Building B - Backup',
      isActive: false,
      lastUpdate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Meter(
      serialNumber: 'PWN-2024-003',
      location: 'Building C - Emergency',
      isActive: true,
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  Meter get _currentMeter => _meters[_selectedMeterIndex];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  void _handleKeyPress(String value) {
    if (!_isPowerOn) return;

    setState(() {
      _status = Status.idle;
      if (value == 'ENTER') {
        _processToken();
      } else if (value == 'BACK') {
        if (_token.isNotEmpty) {
          _token = _token.substring(0, _token.length - 1);
        }
      } else if (value == 'POWER') {
        _togglePower();
      } else if (int.tryParse(value) != null) {
        if (_token.length < _maxTokenLength) {
          _token += value;
        }
      }
    });
  }

  void _togglePower() {
    setState(() {
      _isPowerOn = !_isPowerOn;
      if (!_isPowerOn) {
        _status = Status.offline;
        _token = '';
      } else {
        _status = Status.idle;
      }
    });
  }

  void _processToken() {
    setState(() {
      _status = Status.processing;
    });

    _scanController.forward().then((_) {
      if (_token.length == _maxTokenLength && _token.startsWith('1234')) {
        setState(() {
          _status = Status.success;
          _token = 'TOKEN ACCEPTED';
        });
      } else {
        setState(() {
          _status = Status.error;
          _token = 'INVALID TOKEN';
        });
      }

      _scanController.reset();

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _token = '';
            _status = Status.idle;
          });
        }
      });
    });
  }

  void _showMeterSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildMeterSelectionSheet(),
    );
  }

  Widget _buildMeterSelectionSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A2329), Color(0xFF0B0E10)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF4A5568),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.electrical_services,
                  color: Color(0xFF00D4FF),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Select Meter',
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00D4FF),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _meters.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final meter = _meters[index];
                final isSelected = index == _selectedMeterIndex;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isSelected
                              ? [
                                const Color(0xFF00D4FF).withOpacity(0.2),
                                const Color(0xFF00A8FF).withOpacity(0.1),
                              ]
                              : [
                                const Color(0xFF2A3A47).withOpacity(0.3),
                                const Color(0xFF1E2832).withOpacity(0.5),
                              ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF00D4FF)
                              : const Color(0xFF3A4A57),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _selectedMeterIndex = index;
                        _token = '';
                        _status = Status.idle;
                      });
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            meter.isActive
                                ? const Color(0xFF00FF88)
                                : const Color(0xFF8E8E93),
                        boxShadow:
                            meter.isActive
                                ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00FF88,
                                    ).withOpacity(0.5),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                                : [],
                      ),
                    ),
                    title: Text(
                      meter.serialNumber,
                      style: GoogleFonts.robotoMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? const Color(0xFF00D4FF) : Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meter.location,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                        Text(
                          'Last update: ${_formatTime(meter.lastUpdate)}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 10,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          isSelected
                              ? const Color(0xFF00D4FF)
                              : const Color(0xFF4A5568),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0E10), Color(0xFF1A1F25), Color(0xFF0B0E10)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildMainPanel(),
                const Spacer(),
                Flexible(
                  flex: 5,
                  child: _buildKeypad(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2A3A47).withOpacity(0.3),
            const Color(0xFF1E2832).withOpacity(0.5),
            const Color(0xFF2A3A47).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A4A57), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _showMeterSelection,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D4FF), Color(0xFF00A8FF)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.swap_horiz,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SWITCH',
                        style: GoogleFonts.robotoMono(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'PAWANE CIU v2.1',
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          _isPowerOn
                              ? const Color(0xFF00D4FF)
                              : const Color(0xFF4A5568),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    _currentMeter.serialNumber,
                    style: GoogleFonts.robotoMono(
                      fontSize: 10,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
              _buildPowerIndicator(),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusIndicators(),
        ],
      ),
    );
  }

  Widget _buildPowerIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                _isPowerOn
                    ? RadialGradient(
                      colors: [
                        Color(0xFF00FF88).withOpacity(_pulseAnimation.value),
                        Color(
                          0xFF00AA55,
                        ).withOpacity(_pulseAnimation.value * 0.3),
                      ],
                    )
                    : const RadialGradient(
                      colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    ),
            border: Border.all(
              color:
                  _isPowerOn
                      ? const Color(0xFF00FF88)
                      : const Color(0xFF4A4A4A),
              width: 2,
            ),
            boxShadow:
                _isPowerOn
                    ? [
                      BoxShadow(
                        color: const Color(
                          0xFF00FF88,
                        ).withOpacity(_pulseAnimation.value * 0.5),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
          child: InkWell(
            onTap: _togglePower,
            customBorder: const CircleBorder(),
            child: Center(
              child: Icon(
                Icons.power_settings_new,
                color: _isPowerOn ? Colors.white : const Color(0xFF666666),
                size: 18,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatusLight(
          label: 'READY',
          color:
              _status == Status.idle && _isPowerOn
                  ? const Color(0xFF00A8FF)
                  : Colors.transparent,
          isActive: _status == Status.idle && _isPowerOn,
        ),
        _StatusLight(
          label: 'PROCESSING',
          color:
              _status == Status.processing
                  ? const Color(0xFFFFB800)
                  : Colors.transparent,
          isActive: _status == Status.processing,
        ),
        _StatusLight(
          label: 'SUCCESS',
          color:
              _status == Status.success
                  ? const Color(0xFF00FF88)
                  : Colors.transparent,
          isActive: _status == Status.success,
        ),
        _StatusLight(
          label: 'ERROR',
          color:
              _status == Status.error
                  ? const Color(0xFFFF3B30)
                  : Colors.transparent,
          isActive: _status == Status.error,
        ),
        _StatusLight(
          label: 'OFFLINE',
          color: !_isPowerOn ? const Color(0xFF8E8E93) : Colors.transparent,
          isActive: !_isPowerOn,
        ),
      ],
    );
  }

  Widget _buildMainPanel() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0F1419),
            const Color(0xFF1A2329),
            const Color(0xFF0F1419),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _isPowerOn
                  ? const Color(0xFF00D4FF).withOpacity(0.3)
                  : const Color(0xFF4A5568),
          width: 2,
        ),
        boxShadow:
            _isPowerOn
                ? [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
                : [],
      ),
      child: Stack(
        children: [
          if (_status == Status.processing)
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return Positioned(
                  left:
                      -50 +
                      (_scanAnimation.value *
                          (MediaQuery.of(context).size.width - 32)),
                  top: 0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF00D4FF).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TOKEN INPUT',
                  style: GoogleFonts.robotoMono(
                    fontSize: 10,
                    color:
                        _isPowerOn
                            ? const Color(0xFF00D4FF)
                            : const Color(0xFF4A5568),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _token.isEmpty
                      ? (_isPowerOn ? '--------------------' : 'SYSTEM OFFLINE')
                      : _token,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoMono(
                    fontSize: _token.length > 15 ? 14 : 20,
                    fontWeight: FontWeight.bold,
                    color: _getDisplayColor(),
                    letterSpacing: 1.5,
                  ),
                ),
                if (_isPowerOn && _token.isNotEmpty && _status == Status.idle)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 2,
                    width: 160,
                    child: LinearProgressIndicator(
                      value: _token.length / _maxTokenLength,
                      backgroundColor: const Color(0xFF2A3A47),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _token.length == _maxTokenLength
                            ? const Color(0xFF00FF88)
                            : const Color(0xFF00D4FF),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getDisplayColor() {
    if (!_isPowerOn) return const Color(0xFF4A5568);

    switch (_status) {
      case Status.idle:
        return const Color(0xFF00D4FF);
      case Status.processing:
        return const Color(0xFFFFB800);
      case Status.success:
        return const Color(0xFF00FF88);
      case Status.error:
        return const Color(0xFFFF3B30);
      case Status.offline:
        return const Color(0xFF8E8E93);
    }
  }

  Widget _buildKeypad() {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'BACK',
      '0',
      'ENTER',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A2329).withOpacity(0.5),
            const Color(0xFF2A3A47).withOpacity(0.3),
            const Color(0xFF1A2329).withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3A4A57), width: 1),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: keys.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final key = keys[index];
          return _KeypadButton(
            label: key,
            onTap: () => _handleKeyPress(key),
            isEnabled: _isPowerOn,
          );
        },
      ),
    );
  }
}

class _KeypadButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isEnabled;

  const _KeypadButton({
    required this.label,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  State<_KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<_KeypadButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _ledController;
  late Animation<double> _ledAnimation;

  @override
  void initState() {
    super.initState();
    _ledController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _ledAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ledController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ledController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    Color ledColor = const Color(0xFF00D4FF);

    if (widget.label == 'BACK') {
      child = Icon(
        Icons.backspace_outlined,
        size: 18,
        color: widget.isEnabled ? ledColor : const Color(0xFF4A5568),
      );
    } else if (widget.label == 'ENTER') {
      ledColor = const Color(0xFF00FF88);
      child = Icon(
        Icons.keyboard_return,
        size: 18,
        color: widget.isEnabled ? ledColor : const Color(0xFF4A5568),
      );
    } else {
      child = Text(
        widget.label,
        style: GoogleFonts.robotoMono(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: widget.isEnabled ? Colors.white : const Color(0xFF4A5568),
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) {
        if (widget.isEnabled) {
          setState(() => _isPressed = true);
          _ledController.forward();
        }
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _ledController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _ledController.reverse();
      },
      onTap: widget.isEnabled ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _ledAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  widget.isEnabled
                      ? RadialGradient(
                        colors:
                            _isPressed
                                ? [
                                  ledColor.withOpacity(0.8),
                                  ledColor.withOpacity(0.2),
                                  const Color(0xFF1A2329),
                                ]
                                : [
                                  const Color(0xFF2A3A47),
                                  const Color(0xFF1A2329),
                                  const Color(0xFF0F1419),
                                ],
                      )
                      : const RadialGradient(
                        colors: [Color(0xFF1A1A1A), Color(0xFF0F0F0F)],
                      ),
              border: Border.all(
                color:
                    widget.isEnabled
                        ? _isPressed
                            ? ledColor
                            : const Color(0xFF3A4A57)
                        : const Color(0xFF2A2A2A),
                width: _isPressed ? 2 : 1,
              ),
              boxShadow:
                  widget.isEnabled && _isPressed
                      ? [
                        BoxShadow(
                          color: ledColor.withOpacity(0.6),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                      : [],
            ),
            child: Center(child: child),
          );
        },
      ),
    );
  }
}

class _StatusLight extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;

  const _StatusLight({
    required this.label,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                isActive
                    ? RadialGradient(colors: [color, color.withOpacity(0.3)])
                    : const RadialGradient(
                      colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    ),
            border: Border.all(
              color: isActive ? color : const Color(0xFF4A4A4A),
              width: 1,
            ),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: color.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.robotoMono(
            fontSize: 7,
            color: isActive ? color : const Color(0xFF666666),
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
