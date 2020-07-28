import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

@UseMoor(tables: [Tasks, Tags], daos: [TaskDao, TagDao])
class Database extends _$Database {
  Database()
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: true,
        )));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // Runs if the database has already been opened on the device with a lower version
        onUpgrade: (migrator, from, to) async {
          if (from == 1) {
            await migrator.addColumn(tasks, tasks.tagName);
            await migrator.createTable(tags);
          }
        },
        // Runs after all the migrations but BEFORE any queries have a chance to execute
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

class Tags extends Table {
  TextColumn get name => text().withLength(min: 1, max: 10)();
  IntColumn get color => integer()();

  // Making name as the primary key of a tag requires names to be unique
  @override
  Set<Column> get primaryKey => {name};
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get tagName => text().nullable().customConstraint('NULL REFERENCES tags(name)')();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
}

class TaskWithTag {
  final Task task;
  final Tag tag;

  TaskWithTag({
    @required this.task,
    @required this.tag,
  });
}

@UseDao(
  tables: [Tasks, Tags],
)
class TaskDao extends DatabaseAccessor<Database> with _$TaskDaoMixin {
  final Database db;

  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTasks() => select(tasks).get();
  //Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);
  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);
  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);

  Stream<List<TaskWithTag>> watchAllTasks() {
    // Wrap the whole select statement in parenthesis
    return (select(tasks)
          // Statements like orderBy and where return void => the need to use a cascading ".." operator
          ..orderBy(
            ([
              // Primary sorting by due date
              (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.asc),
              // Secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.name),
            ]),
          ))
        // As opposed to orderBy or where, join returns a value. This is what we want to watch/get.
        .join(
          [
            // Join all the tasks with their tags.
            // It's important that we use equalsExp and not just equals.
            // This way, we can join using all tag names in the tasks table, not just a specific one.
            leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName)),
          ],
        )
        // watch the whole select statement including the join
        .watch()
        // Watching a join gets us a Stream of List<TypedResult>
        // Mapping each List<TypedResult> emitted by the Stream to a List<TaskWithTag>
        .map(
          (rows) => rows.map(
            (row) {
              return TaskWithTag(
                task: row.readTable(tasks),
                tag: row.readTable(tags),
              );
            },
          ).toList(),
        );
  }

  Stream<List<Task>> watchCompletedTasks() {
    // where returns void, need to use the cascading operator
    return (select(tasks)
          ..orderBy(
            ([
              // Primary sorting by due date
              (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
              // Secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.name),
            ]),
          )
          ..where((t) => t.completed.equals(true)))
        .watch();
  }
}

@UseDao(tables: [Tags])
class TagDao extends DatabaseAccessor<Database> with _$TagDaoMixin {
  final Database db;

  TagDao(this.db) : super(db);

  Stream<List<Tag>> watchTags() => select(tags).watch();
  Future insertTag(Insertable<Tag> tag) => into(tags).insert(tag);
}
