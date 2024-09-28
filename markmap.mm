import { Transformer } from 'markmap-lib';
import { fillTemplate } from 'markmap-render';
import nodeHtmlToImage from 'node-html-to-image';
import { writeFile } from 'node:fs/promises';

async function renderMarkmap(markdown: string, outFile: string) {
    const transformer = new Transformer();
    const { root, features } = transformer.transform(markdown);
    const assets = transformer.getUsedAssets(features);
    const html =
        fillTemplate(root, assets, {
            jsonOptions: {
                duration: 0,
                maxInitialScale: 5,
            },
        }) +
        `
<style>
body,
#mindmap {
  width: 2400px;
  height: 1800px;
}
</style>
`;
    const image = await nodeHtmlToImage({
        html,
    });
    await writeFile(outFile, image);
}

renderMarkmap(markdown, 'markmap.png');