import { Assembly } from "jsii-reflect";
import { IGenerator, Legalese } from "../generator";
import { Target, TargetOptions } from "../target";
import { RosettaTabletReader } from "jsii-rosetta";
import { CodeMaker } from "codemaker";
import * as fs from 'fs-extra';
import * as path from 'path';

export class Dart extends Target {
    protected readonly generator: DartGenerator;

    public constructor(options: TargetOptions) {
        super(options);
        this.generator = new DartGenerator(options);
    }

    public async build(sourceDir: string, outDir: string): Promise<void> {
        await this.copyFiles(sourceDir, outDir);
    }

}

class DartGenerator implements IGenerator {
    private assembly!: Assembly;
    private readonly code = new DartCodeMaker({
        indentCharacter: ' ',
        indentationLevel: 2,
    });

    public constructor(options: {
        readonly rosetta: RosettaTabletReader;
        readonly runtimeTypeChecking: boolean;
    }) {

    }

    public async load(packageDir: string, assembly: Assembly): Promise<void> {
        this.assembly = assembly;
    }

    public generate(fingerprint: boolean): void {
        // TODO
    }

    public async upToDate(_outDir: string): Promise<boolean> {
        return false;
    }

    public async save(outdir: string, tarball: string, { license, notice }: Legalese): Promise<void> {
        await this.embedTarball(tarball);
        await this.code.save(outdir);

        if (license) {
            await fs.writeFile(path.join(outdir, 'LICENSE'), license, {
                encoding: 'utf8',
            });
        }

        if (notice) {
            await fs.writeFile(path.join(outdir, 'NOTICE'), notice, {
                encoding: 'utf8',
            });
        }
    }

    /**
     * Embeds the tarball into a Dart file which can be compiled into the artifact.
     * 
     * Other languages run in JIT mode and can, at runtime, retrieve and process the
     * tarball. Dart, however, is meant to be compiled into a single executable, so we
     * embed the tarball contents in a Dart file so that it can be reassembled at
     * runtime and sent to the JSII engine.
     * 
     * @param tarball the path to the tarball.
     */
    private async embedTarball(tarball: string) {
        const contents = await this.readTarball(tarball);

        this.code.withFile('lib/src/tarball.dart', code => {
            code.addImport('dart:typed_data');
            code.line();
            code.line('final tarball = Uint8List.fromList([');
            for (const byte of contents) {
                const hexDigit = `0x${byte.toString(16).padStart(2, '0')}`;
                code.line(`${hexDigit},`);
            }
            code.line(']);');
        });
    }

    /**
     * Reads a tarball to a `Buffer`.
     * 
     * @param path the path to the tarball.
     * @returns the contents of the tarball.
     */
    private readTarball(path: string): Promise<Buffer> {
        return new Promise((resolve, reject) => {
            const rs = fs.createReadStream(path);
            const bufs: Buffer[] = [];
            rs.on('data', chunk => {
                bufs.push(Buffer.from(chunk));
            });
            rs.on('error', reject);
            rs.on('end', () => {
                resolve(Buffer.concat(bufs));
            });
        })
    }

}

class DartCodeMaker extends CodeMaker {
    addImport(uri: string): void {
        this.line(`import '${uri}';`);
    }

    withFile(filePath: string, body: (code: DartCodeMaker) => void): void {
        this.openFile(filePath);
        body(this);
        this.closeFile(filePath);
    }
}
