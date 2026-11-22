import 'package:flutter/material.dart';

void main() => runApp(const PhantomApp());

const Color _background = Color(0xFF0B0D14);
const Color _surface = Color(0xFF151927);
const Color _purple = Color(0xFF9B7BFF);
const Color _cyan = Color(0xFF42DCC6);
const Color _muted = Color(0xFF9299AE);

class PhantomApp extends StatelessWidget {
  const PhantomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PHANTOM',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _background,
        colorScheme: const ColorScheme.dark(
          primary: _purple,
          secondary: _cyan,
          surface: _surface,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: PhantomHome(),
      ),
    );
  }
}

class PhantomHome extends StatefulWidget {
  const PhantomHome({super.key});

  @override
  State<PhantomHome> createState() => _PhantomHomeState();
}

class _PhantomHomeState extends State<PhantomHome> {
  int _selectedIndex = 0;
  final List<_Task> _tasks = [
    _Task('مرور درس برنامه‌نویسی', 'امروز · ۳۰ دقیقه', true),
    _Task('تمرین ورزشی', 'امروز · ۴۵ دقیقه', false),
    _Task('مطالعه کتاب', 'امشب · ۲۰ دقیقه', false),
  ];
  final List<_Habit> _habits = [
    _Habit('نوشیدن آب', '۸ لیوان در روز', Icons.water_drop_rounded, true),
    _Habit('مطالعه', '۲۰ دقیقه در روز', Icons.menu_book_rounded, false),
    _Habit('ورزش', '۳۰ دقیقه در روز', Icons.fitness_center_rounded, true),
  ];

  int get _completedTasks => _tasks.where((task) => task.done).length;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboard(),
      _tasksPage(),
      _habitsPage(),
      _statsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: _surface,
        indicatorColor: _purple.withValues(alpha: 0.18),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'خانه',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline_rounded),
            label: 'وظایف',
          ),
          NavigationDestination(
            icon: Icon(Icons.track_changes_rounded),
            label: 'عادت‌ها',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_rounded),
            label: 'آمار',
          ),
        ],
      ),
    );
  }

  Widget _dashboard() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_purple, _cyan]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.blur_on_rounded,
                  color: Colors.white, size: 29),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PHANTOM',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.2,
                      )),
                  Text('کنترل زندگی، یک روز در هر بار',
                      style: TextStyle(color: _muted, fontSize: 11)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showInfo(),
              icon: const Icon(Icons.notifications_none_rounded),
              style: IconButton.styleFrom(
                backgroundColor: _surface,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const Text('داشبورد امروز',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('قدم‌های کوچک، پیشرفت‌های بزرگ.',
            style: TextStyle(color: _muted)),
        const SizedBox(height: 22),
        _progressCard(),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                icon: Icons.task_alt_rounded,
                title: 'وظایف انجام‌شده',
                value: '$_completedTasks/${_tasks.length}',
                color: _cyan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _metricCard(
                icon: Icons.local_fire_department_rounded,
                title: 'روزهای پیوسته',
                value: '۵ روز',
                color: const Color(0xFFFFB454),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        _sectionHeader('وظایف امروز', 'مشاهده همه', () {
          setState(() => _selectedIndex = 1);
        }),
        const SizedBox(height: 10),
        ..._tasks.take(3).map(_taskTile),
        const SizedBox(height: 22),
        _sectionHeader('عادت‌های من', 'مدیریت', () {
          setState(() => _selectedIndex = 2);
        }),
        const SizedBox(height: 10),
        ..._habits.map(_habitTile),
      ],
    );
  }

  Widget _progressCard() {
    final progress = _tasks.isEmpty ? 0.0 : _completedTasks / _tasks.length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF292344), Color(0xFF171D2D)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _purple.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt_rounded, color: _cyan),
              SizedBox(width: 8),
              Text('عملکرد امروز',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              Spacer(),
              Text('امروز', style: TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(
                      fontSize: 38, fontWeight: FontWeight.w900)),
              const Spacer(),
              Text('$_completedTasks از ${_tasks.length} وظیفه',
                  style: const TextStyle(color: _muted)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(_cyan),
            ),
          ),
          const SizedBox(height: 12),
          const Text('به مسیرت ادامه بده؛ ثبات از سرعت مهم‌تر است.',
              style: TextStyle(color: Color(0xFFC3C6D4), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 14),
          Text(value,
              style:
                  const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(color: _muted, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, String action, VoidCallback onTap) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(action, style: const TextStyle(color: _cyan)),
        ),
      ],
    );
  }

  Widget _taskTile(_Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CheckboxListTile(
        value: task.done,
        onChanged: (value) => setState(() => task.done = value ?? false),
        activeColor: _cyan,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 13,
            decoration: task.done ? TextDecoration.lineThrough : null,
            color: task.done ? _muted : Colors.white,
          ),
        ),
        subtitle: Text(task.time,
            style: const TextStyle(color: _muted, fontSize: 11)),
      ),
    );
  }

  Widget _habitTile(_Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: _purple.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(habit.icon, color: _purple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(habit.subtitle,
                    style: const TextStyle(color: _muted, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: habit.done,
            activeColor: _cyan,
            onChanged: (value) => setState(() => habit.done = value),
          ),
        ],
      ),
    );
  }

  Widget _tasksPage() {
    return _pageScaffold(
      'وظایف',
      'کارهای مهمت را ثبت و پیگیری کن.',
      [
        ..._tasks.map(_taskTile),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _addTask,
          icon: const Icon(Icons.add),
          label: const Text('افزودن وظیفه'),
        ),
      ],
    );
  }

  Widget _habitsPage() {
    return _pageScaffold(
      'عادت‌ها',
      'عادت‌های کوچک، نتایج ماندگار.',
      [
        ..._habits.map(_habitTile),
        const SizedBox(height: 12),
        const _HintCard(
          text: 'هر روز فقط روی بهتر شدن یک درصدی تمرکز کن.',
          icon: Icons.tips_and_updates_outlined,
        ),
      ],
    );
  }

  Widget _statsPage() {
    final percent =
        _tasks.isEmpty ? 0 : (_completedTasks / _tasks.length * 100).round();
    return _pageScaffold(
      'آمار و پیشرفت',
      'نمای کلی از عملکرد ثبت‌شده تو.',
      [
        _metricCard(
          icon: Icons.task_alt_rounded,
          title: 'وظایف تکمیل‌شده',
          value: '$_completedTasks',
          color: _cyan,
        ),
        const SizedBox(height: 12),
        _metricCard(
          icon: Icons.track_changes_rounded,
          title: 'عادت‌های فعال امروز',
          value: '${_habits.where((h) => h.done).length}/${_habits.length}',
          color: _purple,
        ),
        const SizedBox(height: 12),
        _metricCard(
          icon: Icons.insights_rounded,
          title: 'درصد تکمیل وظایف',
          value: '$percent%',
          color: const Color(0xFFFFB454),
        ),
        const SizedBox(height: 18),
        const _HintCard(
          text: 'این نسخه اطلاعات را در حافظه موقت نگه می‌دارد. ذخیره‌سازی دائمی در نسخه بعدی اضافه می‌شود.',
          icon: Icons.info_outline_rounded,
        ),
      ],
    );
  }

  Widget _pageScaffold(String title, String subtitle, List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        Text(title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: _muted)),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }

  Future<void> _addTask() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surface,
        title: const Text('وظیفه جدید'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'عنوان وظیفه'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('افزودن'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (title != null && title.isNotEmpty) {
      setState(() => _tasks.add(_Task(title, 'بدون زمان‌بندی', false)));
    }
  }

  void _showInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _surface,
        title: const Text('PHANTOM'),
        content: const Text(
            'نسخه اولیه اپلیکیشن مدیریت زندگی شخصی. امکانات بیشتر در نسخه‌های بعدی اضافه می‌شوند.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('متوجه شدم'),
          ),
        ],
      ),
    );
  }
}

class _Task {
  _Task(this.title, this.time, this.done);
  final String title;
  final String time;
  bool done;
}

class _Habit {
  _Habit(this.title, this.subtitle, this.icon, this.done);
  final String title;
  final String subtitle;
  final IconData icon;
  bool done;
}

class _HintCard extends StatelessWidget {
  const _HintCard({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(icon, color: _cyan),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Color(0xFFC3C6D4), height: 1.6)),
          ),
        ],
      ),
    );
  }
}
