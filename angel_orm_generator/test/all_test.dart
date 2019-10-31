import 'package:angel_orm_generator/angel_orm_generator.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';

main() {
  group('migration generator', _migrationGeneratorGroup);
}

_migrationGeneratorGroup() {
  test('unique is generated', () async {
    final builder =
        migrationBuilder(BuilderOptions({'auto_snake_case_names': true}));
    await testBuilder(
      builder,
      {'app|lib/client.dart': clientSource},
      reader: await PackageAssetReader.currentIsolate(),
      generateFor: {'app|lib/client.dart'},
      outputs: {'app|lib/client.angel_migration.g.part': decodedMatches(contains('unique'))},
      onLog: (log) => print(log),
    );
  });
}

const clientSource = """import 'package:angel_migration/angel_migration.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_orm/angel_orm.dart';

part 'client.g.dart';

@serializable
@orm
abstract class _Client extends Model {
  @Column(isNullable: false)
  bool get revoked;

  @Column(isNullable: false, indexType: IndexType.unique)
  String get name;

  @Column(isNullable: false)
  String get secret;
}""";
